
class CurrencyConverterPresenterImpl: NSObject {
    fileprivate var baseCurrency: ExchangeAbbreviation?
    fileprivate var conversionValue: Double?
    fileprivate var refreshTimer: Timer?
    
    fileprivate let reloadTimeInterval = 1800.0
    fileprivate let currencyInteractor = ExchangeRateInteractor()
    
    weak var currencyView: CurrencyConverterView?
    
    override init() {
        super.init()
        
        refreshTimer = Timer.scheduledTimer(timeInterval: reloadTimeInterval, target: self, selector: #selector(updateExchangeRates(sender:)), userInfo: nil, repeats: true)
        refreshTimer?.fire()
    }
    
    func updateExchangeRates(sender: Timer) {
        guard let base = baseCurrency else {
            return
        }
        
        currencyInteractor.fetchExchangeRates(with: base)
    }
    
    deinit {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}

extension CurrencyConverterPresenterImpl: CurrencyConverterPresenter {
    func viewDidLoad() {
        currencyInteractor.listenerDelegate = self
    }
    
    func loadCurrencyValues(with baseCurrency: ExchangeAbbreviation, valueToConvert: Double) {
        self.baseCurrency = baseCurrency
        conversionValue = valueToConvert
        
        currencyInteractor.fetchAndStoreCurrencyExchangeRates(with: baseCurrency)
    }
    
    func updateRates(with newValue: Double) {
        guard let base = baseCurrency else {
            return
        }
        
        conversionValue = newValue
        currencyInteractor.fetchExchangeRates(with: base)
    }
    
    fileprivate func convertExchangeRateToPresentable(rates: ExchangeRate) -> CurrencyConverterData {
        let items = createItemsArray(from: rates)
        return CurrencyConverterData(currencyItems: items)
    }
    
    fileprivate func createItemsArray(from ratesArray: ExchangeRate) -> [CurrencyItem] {
        return ratesArray.map { rate -> CurrencyItem? in
            guard let abbreviation = ExchangeAbbreviation(rawValue: rate.key),
                let exchangeRate = rate.value as? Double,
                let baseValue = conversionValue else {
                    return nil
            }
            
            let convertedCurrency = baseValue * exchangeRate
            let convertedCurrencyString = String(format: "%.2f", convertedCurrency)
            
            return CurrencyItem(currencyAbbreviation: abbreviation.rawValue, fullCurrencyName: abbreviation.presentableString(), equivalentCurrency: convertedCurrencyString)
        }.flatMap { $0 }
    }
}

extension CurrencyConverterPresenterImpl: InteractorListenerDelegate {
    func exchangeRatesUpdated(rates: ExchangeRate) {
        let viewData = convertExchangeRateToPresentable(rates: rates)
        currencyView?.updateViewData(data: viewData)
    }
}
