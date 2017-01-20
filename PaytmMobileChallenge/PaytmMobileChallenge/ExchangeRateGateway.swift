
import BrightFutures
import Result

protocol ExchangeRateGateway {
    func fetchExchangeRates(with baseCurrency: ExchangeAbbreviations) -> Future<ExchangeRates, NoError>
    func syncAndFetchExchangeRates(with baseCurrency: ExchangeAbbreviations) -> Future<ExchangeRates, NoError>
}
