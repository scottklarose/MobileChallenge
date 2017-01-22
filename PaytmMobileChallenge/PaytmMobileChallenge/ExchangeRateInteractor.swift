
import Foundation


class ExchangeRateInteractor: NSObject {
    fileprivate let reloadTimeInterval = 1800.0
    fileprivate let exchangeRateGteway: ExchangeRateGateway = CouchbaseExchangeRateGateway(databaseName: "exchangeratedb")
    fileprivate var refreshTimer: Timer?
    
    weak var presenter: CurrencyConverterPresenter?
    
    override init() {
        super.init()
        
        refreshTimer = Timer.scheduledTimer(timeInterval: reloadTimeInterval, target: self, selector: #selector(updateExchangeRates(sender:)), userInfo: nil, repeats: true)
        refreshTimer?.fire()
    }
    
    func fetchAndStoreCurrencyExchangeRates(with baseCurrency: ExchangeAbbreviation) {
        exchangeRateGteway.syncExchangeRates(with: baseCurrency).onSuccess { [weak self] rates in
            self?.presenter?.presentCurrencyExchangeRates(rates: rates)
        }
    }
    
    func updateExchangeRates(sender: Timer) {
        guard let baseCurrency = presenter?.currentBaseCurrency() else {
            return
        }
        
        fetchAndStoreCurrencyExchangeRates(with: baseCurrency)
    }
    
    deinit {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    func fetchExchangeRates(with baseCurrency: ExchangeAbbreviation) {
        exchangeRateGteway.fetchExchangeRates(with: baseCurrency).onSuccess { [weak self] rates in
            self?.presenter?.presentCurrencyExchangeRates(rates: rates)
        }
    }
}
