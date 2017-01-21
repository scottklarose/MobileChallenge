
class CurrencyConverterPresenterImpl {
    weak var currencyView: CurrencyConverterView?
    let currencyInteractor = ExchangeRateInteractor()
}

extension CurrencyConverterPresenterImpl: CurrencyConverterPresenter {
    func viewDidLoad() {
        currencyInteractor.presenter = self
        
        
    }
    
    func presentCurrencyExchangeRates(rates: ExchangeRate) {
        let viewData = convertExchangeRateToPresentable(rates: rates)
        currencyView?.updateViewData(data: viewData)
    }
    
    fileprivate func convertExchangeRateToPresentable(rates: ExchangeRate) -> CurrencyConverterData {
        let items = rates.map { rate -> CurrencyItem? in
            guard let abbreviation = ExchangeAbbreviation(rawValue: rate.key),
                    let rate = rate.value as? String else {
                return nil
            }
            
            return CurrencyItem(currencyAbbreviation: abbreviation, currencyRate: rate)
        }.flatMap { $0 }
        
        return CurrencyConverterData(currencyItems: items)
    }
}



