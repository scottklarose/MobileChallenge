
import BrightFutures
import Result

protocol ExchangeRateGateway {
    func fetchExchangeRates(with baseCurrency: ExchangeAbbreviations) -> Future<ExchangeRates, NoError>
}
