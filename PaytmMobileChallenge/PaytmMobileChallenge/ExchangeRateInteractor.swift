
import Foundation


protocol InteractorListenerDelegate: class {
    func exchangeRatesUpdated(rates: ExchangeRate)
}

class ExchangeRateInteractor: NSObject {
    fileprivate let exchangeRateGteway: ExchangeRateGateway = CouchbaseExchangeRateGateway(databaseName: "exchangeratedb")
    
    weak var listenerDelegate: InteractorListenerDelegate?
    
    func fetchAndStoreCurrencyExchangeRates(with baseCurrency: ExchangeAbbreviation) {
        exchangeRateGteway.syncExchangeRates(with: baseCurrency).onSuccess { [weak self] rates in
            self?.listenerDelegate?.exchangeRatesUpdated(rates: rates)
        }
    }
        
    func fetchExchangeRates(with baseCurrency: ExchangeAbbreviation) {
        exchangeRateGteway.fetchExchangeRates(with: baseCurrency).onSuccess { [weak self] rates in
            self?.listenerDelegate?.exchangeRatesUpdated(rates: rates)
        }
    }
}
