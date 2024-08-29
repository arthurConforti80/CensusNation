//
//  ApiServiceTests.swift
//  CensusUSATests
//
//  Created by Arthur Conforti on 29/08/2024.
//
import XCTest
import OHHTTPStubs
@testable import CensusUSA

class APIServiceTests: XCTestCase {

    var apiService: APIService!

    override func setUp() {
        super.setUp()
        apiService = APIService()
        HTTPStubs.removeAllStubs()
    }

    override func tearDown() {
        apiService = nil
        HTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    
    func testFetchNationPopulationSuccess() {
        let expectation = self.expectation(description: "Fetch nation population success")

        apiService.fetchNationPopulation { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
                XCTAssertTrue(data.count > 0)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testFetchNationPopulationFailure() {
        HTTPStubs.stubRequests(passingTest: { request in
            return request.url?.host == "datausa.io" && request.url?.path == "/api/data"
        }) { _ in
            return HTTPStubsResponse(error: NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil))
        }
        
        let expectation = self.expectation(description: "Fetch nation population failure")
        apiService.fetchNationPopulation { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 3.0, handler: nil)
    }
}

