
protocol CurrencyConverterPresenter: class {
    func viewDidLoad()
    
    func loadCurrencyValues(with baseCurrency: ExchangeAbbreviation, valueToConvert: Double)
    func updateRates(with newValue: Double)
}
