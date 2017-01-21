
struct CurrencyConverterData {
    let currencyItems: [CurrencyItem]
}

struct CurrencyItem {
    let currencyAbbreviation: ExchangeAbbreviation
    let currencyRate: String
}
