
import BrightFutures
import Foundation
import Result


class CouchbaseExchangeRateGateway: ExchangeRateGateway {
    fileprivate let fixerEndPoint = "https://api.fixer.io/latest"
    fileprivate let couchbaseManager = CBLManager.sharedInstance()
    
    init() {
        
    }
    
    func syncAndFetchExchangeRates(with baseCurrency: ExchangeAbbreviations) -> Future<ExchangeRates, NoError> {
        return Future<ExchangeRates, NoError>()
    }
    
    func fetchExchangeRates(with baseCurrency: ExchangeAbbreviations) -> Future<ExchangeRates, NoError> {
        let fixerUrlString = fixerEndPoint + "?base=\(baseCurrency.rawValue)"
        
        guard let fixerUrl = URL(string: fixerUrlString) else {
            return Future<ExchangeRates, NoError>()
        }
        
        return requestExchangeRatesFromFixer(base: baseCurrency, requestUrl: fixerUrl)
    }
    
    fileprivate func requestExchangeRatesFromFixer(base: ExchangeAbbreviations, requestUrl: URL) -> Future<ExchangeRates, NoError> {
        let exchangeRatesPromise = Promise<ExchangeRates, NoError>()
        
        let task = URLSession.shared.dataTask(with: requestUrl) { [weak self] data, response, error in
            guard let `self` = self else {
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            exchangeRatesPromise.success(self.handleFixerResponse(resppnseData: data))
        }
        
        task.resume()
        return exchangeRatesPromise.future
    }
    
    fileprivate func handleFixerResponse(resppnseData: Data?) -> ExchangeRates {
        guard let data = resppnseData else {
            return  ExchangeRates()
        }
        
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
                let response = jsonResponse as? [String: Any] else{
            return  ExchangeRates()
        }
        
        return  formatResponseIntoExchangeRates(response: response)
    }
    
    fileprivate func formatResponseIntoExchangeRates(response: [String: Any]) -> ExchangeRates {
        guard let exchangeRates = response["rates"] as? [String: Any] else {
            return ExchangeRates()
        }
        
        return exchangeRates.map {
            return [$0.key: $0.value as? Double ?? 0]
        }
    }
}
