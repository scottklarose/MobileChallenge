
import Foundation


class ExchangeRateInteractor: NSObject {
    fileprivate let reloadTimeInterval = 5.0
    fileprivate let exchangeRateGteway: ExchangeRateGateway = CouchbaseExchangeRateGateway()
    fileprivate var refreshTimer: Timer?
    
    override init() {
        super.init()
        
        refreshTimer = Timer.scheduledTimer(timeInterval: reloadTimeInterval, target: self, selector: #selector(updateView(sender:)), userInfo: nil, repeats: true)
        refreshTimer?.fire()
    }
    
    func updateView(sender: Timer) {
        print("")
    }
    
    deinit {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}
