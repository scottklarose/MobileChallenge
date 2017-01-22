
protocol CurrencyConverterPresenter: class {
    func loadCurrencyValues(with baseCurrency: ExchangeAbbreviation, valueToConvert: Double)
    func updateRates(with newValue: Double)
    
    func presentCurrencyExchangeRates(rates: ExchangeRate)
    func currentBaseCurrency() -> ExchangeAbbreviation?
}
