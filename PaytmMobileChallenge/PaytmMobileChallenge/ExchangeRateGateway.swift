
import BrightFutures
import Result

protocol ExchangeRateGateway {
    func fetchExchangeRates(with baseCurrency: ExchangeAbbreviation) -> Future<ExchangeRate, NoError>
    func syncExchangeRates(with baseCurrency: ExchangeAbbreviation) -> Future<ExchangeRate, NoError>
    
    func destroyGateway()
}
