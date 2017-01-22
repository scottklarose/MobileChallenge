
class CurrencyConverterPresenterImpl {
    fileprivate var baseCurrency: ExchangeAbbreviation?
    fileprivate var conversionValue: Double?
    
    var currencyInteractor: ExchangeRateInteractor?
    weak var currencyView: CurrencyConverterView?
}

extension CurrencyConverterPresenterImpl: CurrencyConverterPresenter {
    func loadCurrencyValues(with baseCurrency: ExchangeAbbreviation, valueToConvert: Double) {
        self.baseCurrency = baseCurrency
        conversionValue = valueToConvert
        
        currencyInteractor?.fetchAndStoreCurrencyExchangeRates(with: baseCurrency)
    }
    
    func updateRates(with newValue: Double) {
        guard let base = baseCurrency else {
            return
        }
        
        conversionValue = newValue
        currencyInteractor?.fetchExchangeRates(with: base)
    }
    
    func presentCurrencyExchangeRates(rates: ExchangeRate) {
        let viewData = convertExchangeRateToPresentable(rates: rates)
        currencyView?.updateViewData(data: viewData)
    }
    
    fileprivate func convertExchangeRateToPresentable(rates: ExchangeRate) -> CurrencyConverterData {
        let items = createItemsArray(from: rates)
        return CurrencyConverterData(currencyItems: items)
    }
    
    fileprivate func createItemsArray(from ratesArray: ExchangeRate) -> [CurrencyItem] {
        return ratesArray.map { rate -> CurrencyItem? in
            guard let abbreviation = ExchangeAbbreviation(rawValue: rate.key),
                let exchangeRate = rate.value as? Double,
                let base = conversionValue else {
                    return nil
            }
            
            let convertedCurrency = base * exchangeRate
            let convertedCurrencyString = String(format: "%.2f", convertedCurrency)
            
            return CurrencyItem(currencyAbbreviation: abbreviation.rawValue, fullCurrencyName: abbreviation.presentableString(), equivalentCurrency: convertedCurrencyString)
        }.flatMap { $0 }
    }
    
    func currentBaseCurrency() -> ExchangeAbbreviation? {
        return baseCurrency
    }
}
