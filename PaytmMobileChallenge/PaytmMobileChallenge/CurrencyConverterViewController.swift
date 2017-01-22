
import Foundation
import UIKit

class CurrencyConverterViewController: UITableViewController {
    @IBOutlet weak var currencyValueField: UITextField!
    @IBOutlet weak var baseCurrencyField: UITextField!
    
    var viewData: CurrencyConverterData?
    var currencyPresenter: CurrencyConverterPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPresenter()
        setupTextFieldDelegates()
        addTapGestureToView()
    }
    
    fileprivate func loadPresenter() {
        currencyPresenter?.loadCurrencyValues(with: .canadianDollar, valueToConvert: 1)
    }
    
    fileprivate func setupTextFieldDelegates() {
        currencyValueField.delegate = self
    }
    
    fileprivate func addTapGestureToView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(recognizer:)))
        view.addGestureRecognizer(tap)
    }
    
    func closeKeyboard(recognizer: UIGestureRecognizer) {
        currencyValueField.resignFirstResponder()
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

extension CurrencyConverterViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = Double(textField.text ?? "") else {
            return
        }
    
        currencyPresenter?.updateRates(with: newValue)
    }
}
