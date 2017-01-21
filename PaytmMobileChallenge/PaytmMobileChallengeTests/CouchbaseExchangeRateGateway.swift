
import XCTest
@testable import PaytmMobileChallenge

class CouchbaseGatewayTests: XCTestCase {
    var exchangeRateGateway: ExchangeRateGateway!
    
    override func setUp() {
        super.setUp()
        
        exchangeRateGateway = CouchbaseExchangeRateGateway(databaseName: "testdb")
    }
    
    override func tearDown() {
        super.tearDown()
        
        exchangeRateGateway.destroyGateway()
    }
    
    func testShould_FetchRatesFromBackend_When_BaseCurrencyIsValid() {
        let fetchExpectation = expectation(description: "Fetch Rates Expectation")
        
        exchangeRateGateway.syncExchangeRates(with: .euro).onSuccess { exchangeRates in
            XCTAssert(exchangeRates.count != 0, "Invlaid amount of rates returned.")
            fetchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testShould_FetchRatesFromLocalStore_When_BaseCurrencyIsValid() {
        let fetchExpectation = expectation(description: "Fetch Rates Expectation")
        
        exchangeRateGateway.fetchExchangeRates(with: .denmarkKrone).onSuccess { exchangeRates in
            XCTAssert(exchangeRates.count != 0, "Invlaid amount of rates returned.")
            fetchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testShould_FetchDifferentFetchTimes_When_SyncedWithBackendMultipleTimes() {
        let fetchedAtExpectation = expectation(description: "Checked fetchedAt Expectation.")
        
        exchangeRateGateway.syncExchangeRates(with: .israelNewShekel).onSuccess { [weak self] syncExchangeRate in
            self?.exchangeRateGateway.syncExchangeRates(with: .israelNewShekel).onSuccess { syncExchangeRateToCompare in
                guard let firstFetchedAt = syncExchangeRate["fetchedAt"] as? Double,
                            let secondFetchedAt = syncExchangeRateToCompare["fetchedAt"] as? Double else {
                    return
                }
                
                XCTAssert(firstFetchedAt != secondFetchedAt, "The fetchedAt values are the same.")
                fetchedAtExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
