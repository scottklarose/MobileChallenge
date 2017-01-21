
protocol CurrencyConverterPresenter: class {
    func viewDidLoad()
    func presentCurrencyExchangeRates(rates: ExchangeRate)
}
