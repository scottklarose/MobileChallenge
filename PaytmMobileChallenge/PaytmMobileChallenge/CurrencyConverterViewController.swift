
import Foundation
import UIKit

class CurrencyConverterViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let interactor = ExchangeRateInteractor()
    }
}
