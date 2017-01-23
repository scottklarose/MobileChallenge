
import Foundation
import UIKit

class CurrencyConverterViewController: UITableViewController {
    @IBOutlet weak var currencyValueField: UITextField!
    
    let currencyAbbrevations = ExchangeAbbreviation.allAbbreviations
    
    var viewData: CurrencyConverterData?
    var currencyPresenter: CurrencyConverterPresenter?
    var sectionHeaderView: CurrencyExchangeHeaderView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialPresenterLoad()
        initializeSectionHeader()
        setupCurrencyValueField()
        addTapGestureToView()
    }
    
    fileprivate func initialPresenterLoad() {
        guard let value = Double(currencyValueField.text ?? "") else {
            return
        }
        
        currencyPresenter?.loadCurrencyValues(with: .canadianDollar, valueToConvert: value)
    }
    
    fileprivate func initializeSectionHeader() {
        sectionHeaderView = Bundle.main.loadNibNamed("CurrencyExchangeHeaderView", owner: self, options: nil)?[0] as? CurrencyExchangeHeaderView
        
        sectionHeaderView?.baseCurrencyField.delegate = self
        sectionHeaderView?.baseCurrencyField.inputView = createChangeBaseCurrencyPicker()
    }
    
    fileprivate func createChangeBaseCurrencyPicker() -> UIPickerView {
        let picker = UIPickerView()
        
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    }
    
    fileprivate func setupCurrencyValueField() {        
        currencyValueField.delegate = self
    }
    
    fileprivate func addTapGestureToView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard(recognizer:)))
        view.addGestureRecognizer(tap)
    }
    
    func closeKeyboard(recognizer: UIGestureRecognizer) {
        currencyValueField.resignFirstResponder()
        sectionHeaderView?.baseCurrencyField.resignFirstResponder()
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
        
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHeaderView
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

extension CurrencyConverterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyAbbrevations.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyAbbrevations[row].presentableString()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let pickedCurrency = currencyAbbrevations[row]
        
        sectionHeaderView?.baseCurrencyField.text = "\(pickedCurrency.rawValue) \(pickedCurrency.presentableString())"
        sectionHeaderView?.baseCurrencyField.resignFirstResponder()
        
        guard let newValue = Double(currencyValueField.text ?? "") else {
            currencyPresenter?.loadCurrencyValues(with: pickedCurrency, valueToConvert: 1)
            currencyValueField.text = "1.00"
            
            return
        }
        
        currencyPresenter?.loadCurrencyValues(with: pickedCurrency, valueToConvert: newValue)
    }
}
