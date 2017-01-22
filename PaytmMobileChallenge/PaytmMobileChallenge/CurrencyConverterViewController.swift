
import Foundation
import UIKit

class CurrencyConverterViewController: UITableViewController {
    var viewData: CurrencyConverterData?
    var currencyPresenter: CurrencyConverterPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPresenter()
    }
    
    fileprivate func loadPresenter() {
        currencyPresenter?.viewDidLoad(with: .canadianDollar, valueToConvert: 1)
    }
    
    //MARK: UITableViewController Override Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData?.currencyItems.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewData?.currencyItems[indexPath.row],
                let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyExchangeTableViewCell", for: indexPath) as? CurrencyExchangeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.populate(item: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension CurrencyConverterViewController: CurrencyConverterView {
    func updateViewData(data: CurrencyConverterData) {
        viewData = data
        tableView.reloadData()
    }
}
