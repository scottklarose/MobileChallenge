
import UIKit


class CurrencyExchangeTableViewCell: UITableViewCell {
    @IBOutlet weak var currencyAbbreviation: UILabel!
    @IBOutlet weak var fullCurrency: UILabel!
    @IBOutlet weak var convertedCurrency: UILabel!
}

extension CurrencyExchangeTableViewCell {
    func populate(item: CurrencyItem) {
        currencyAbbreviation.text = item.currencyAbbreviation
        convertedCurrency.text = item.equivalentCurrency
        fullCurrency.text = item.fullCurrencyName
    }
}
