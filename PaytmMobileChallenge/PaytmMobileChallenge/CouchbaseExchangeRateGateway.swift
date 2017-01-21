
import BrightFutures
import Foundation
import Result


class CouchbaseExchangeRateGateway {
    fileprivate let fixerEndPoint = "https://api.fixer.io/latest"
    fileprivate let couchbaseManager = CBLManager.sharedInstance()
    fileprivate var couchbaseDatabase: CBLDatabase?
    
    fileprivate let currencyBaseKey = "baseCurrencyId"
    fileprivate let fetchTimeKey = "fetchedAt"
    fileprivate let exchangeRateViewName = "byBaseId"

    fileprivate var exchangeRateView: CBLView?
    fileprivate var baseCurrency: ExchangeAbbreviation?
    
    fileprivate var databaseName: String
    
    init(databaseName: String) {
        self.databaseName = databaseName
        
        initializeCouchBaseStore()
    }
    
    deinit {
        destroyGateway()
    }
    
    fileprivate func initializeCouchBaseStore() {
        do {
            couchbaseDatabase = try couchbaseManager.databaseNamed(databaseName)
        } catch {
            print("Data base initialization failed with error: \(error.localizedDescription)")
        }
        
        initializeDatabaseViews()
    }
    
    fileprivate func initializeDatabaseViews() {
        exchangeRateView = couchbaseDatabase?.viewNamed(exchangeRateViewName)
        
        let block: CBLMapBlock = { (doc, emit) in
            emit(doc[self.currencyBaseKey] ?? "", nil)
        }
        
        exchangeRateView?.setMapBlock(block, version: "1")
    }
}

extension CouchbaseExchangeRateGateway: ExchangeRateGateway {
    //MARK: ExchangeRateGateway Methods
    func fetchExchangeRates(with baseCurrency: ExchangeAbbreviation) -> Future<ExchangeRate, NoError> {
        self.baseCurrency = baseCurrency
        
        return Future<ExchangeRate, NoError> { complete in
            queryRate().onSuccess { [weak self] document in
                DispatchQueue.main.async {
                    guard let `self` = self else {
                        return
                    }
                
                    self.checkQueryResult(document: document, complete: complete)
                }
            }
        }
    }
    
    fileprivate func checkQueryResult(document: CBLDocument?, complete: @escaping (Result<ExchangeRate, NoError>) -> Void) {
        guard let base = baseCurrency else {
            return
        }
        
        if let properties = document?.userProperties {
            complete(.success(properties))
            return
        }
        
        syncExchangeRates(with: base).onSuccess { rates in
            complete(.success(rates))
        }
    }
    
    func syncExchangeRates(with baseCurrency: ExchangeAbbreviation) -> Future<ExchangeRate, NoError> {
        let fixerUrlString = fixerEndPoint + "?base=\(baseCurrency.rawValue)"
        self.baseCurrency = baseCurrency
        
        guard let fixerUrl = URL(string: fixerUrlString) else {
            return Future<ExchangeRate, NoError>()
        }
        
        return requestExchangeRatesFromFixer(requestUrl: fixerUrl)
    }
    
    fileprivate func requestExchangeRatesFromFixer(requestUrl: URL) -> Future<ExchangeRate, NoError> {
        let exchangeRatesPromise = Promise<ExchangeRate, NoError>()
        
        let task = URLSession.shared.dataTask(with: requestUrl) { [weak self] data, response, error in
            guard let `self` = self else {
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let formattedExchangeRates = self.handleFixerResponse(resppnseData: data)
            self.persistExchngeRates(rates: formattedExchangeRates)
            
            exchangeRatesPromise.success(formattedExchangeRates)
        }
        
        task.resume()
        return exchangeRatesPromise.future
    }
    
    fileprivate func handleFixerResponse(resppnseData: Data?) -> ExchangeRate {
        guard let data = resppnseData,
                let base = baseCurrency else {
            return  ExchangeRate()
        }
        
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []),
            let response = jsonResponse as? [String: Any],
                var exchangeRates = response["rates"] as? ExchangeRate else {
            return  ExchangeRate()
        }
        
        exchangeRates[currencyBaseKey] = base.rawValue
        exchangeRates[self.fetchTimeKey] = Date().timeIntervalSince1970
        
        return exchangeRates
    }
    
    fileprivate func persistExchngeRates(rates: ExchangeRate) {
        queryRate().onSuccess { [weak self] currencyDocument in
            DispatchQueue.main.async {
                guard let `self` = self,
                        let base = self.baseCurrency else {
                    return
                }
                
                var exchangeProperties = rates
                exchangeProperties[self.currencyBaseKey] = base.rawValue
                
                if let document = currencyDocument {
                    self.updateDocument(document: document, properties: exchangeProperties)
                    return
                }
                
                self.saveNewDocument(properties: exchangeProperties)
            }
        }
    }
    
    fileprivate func queryRate() -> Future<CBLDocument?, NoError> {
        guard let base = baseCurrency else {
            return Future<CBLDocument?, NoError>()
        }
        
        let queryPromise = Promise<CBLDocument?, NoError>()
        let query = couchbaseDatabase?.viewNamed(exchangeRateViewName).createQuery()
        
        query?.keys = [base.rawValue]
        query?.limit = 1

        query?.runAsync() { (enumerator, error) in
            if enumerator.count == 0 {
                queryPromise.success(nil)
                return
            }
                
            queryPromise.success(enumerator.row(at: 0).document)
        }
        
        return queryPromise.future
    }
    
    fileprivate func updateDocument(document: CBLDocument, properties: ExchangeRate) {
        do {
            try document.update { unsavedRevision in
                unsavedRevision.userProperties = properties
                return true
            }
        } catch {
            print("Failed to update new document: \(error.localizedDescription)")
        }
    }
    
    fileprivate func saveNewDocument(properties: ExchangeRate) {
        do {
            let doc = couchbaseDatabase?.createDocument()
            
            try doc?.update { unsavedrevision in
                unsavedrevision.userProperties = properties
                return true
            }
        } catch {
            print("Failed to save new document: \(error.localizedDescription)")
        }
    }
    
    func destroyGateway() {
        try? couchbaseDatabase?.delete()
        couchbaseDatabase = nil
    }
}
