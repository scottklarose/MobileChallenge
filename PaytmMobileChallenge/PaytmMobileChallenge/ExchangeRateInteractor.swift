
import Foundation


class ExchangeRateInteractor: NSObject {
    fileprivate let reloadTimeInterval = 5.0
    fileprivate let exchangeRateGteway: ExchangeRateGateway = CouchbaseExchangeRateGateway(databaseName: "exchangeratedb")
    fileprivate var refreshTimer: Timer?
    
    weak var presenter: CurrencyConverterPresenter?
    
    override init() {
        super.init()
        
        refreshTimer = Timer.scheduledTimer(timeInterval: reloadTimeInterval, target: self, selector: #selector(updateExchangeRates(sender:)), userInfo: nil, repeats: true)
        refreshTimer?.fire()
    }
    
    func updateExchangeRates(sender: Timer) {
        print("")
    }
    
    func fetchExchangeRates() {
        
    }
    
    deinit {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}
