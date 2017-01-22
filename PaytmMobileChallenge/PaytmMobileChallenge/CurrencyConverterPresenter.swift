
protocol CurrencyConverterPresenter: class {
    func viewDidLoad(with baseCurrency: ExchangeAbbreviation, valueToConvert: Double)
    func presentCurrencyExchangeRates(rates: ExchangeRate)
    func updateBaseCurrency(base: ExchangeAbbreviation)
}
