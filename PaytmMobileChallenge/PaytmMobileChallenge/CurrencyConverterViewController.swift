
import Foundation
import UIKit

class CurrencyConverterViewController: UITableViewController {
    var viewData: CurrencyConverterData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: UITableViewController Override Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData?.currencyItems.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = viewData?.currencyItems[indexPath.row] else {
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
}

extension CurrencyConverterViewController: CurrencyConverterView {
    func updateViewData(data: CurrencyConverterData) {
        viewData = data
        tableView.reloadData()
    }
}


