//
//  PopulationViewModelTests.swift
//  CensusUSATests
//
//  Created by Arthur Conforti on 29/08/2024.
//

import XCTest
@testable import CensusUSA

class PopulationViewModelTests: XCTestCase {

    var viewModel: PopulationViewModel!
    var mockAPIService: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = PopulationViewModel()
        viewModel.apiService = mockAPIService // Assume apiService can be set for testing
    }

    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }

    func testFetchPopulationDataForNationSuccess() {
        let mockData = [PopulationData(idNation: "01000US", idState: nil, nation: "United States", state: nil, idYear: 2022, year: "2022", population: 331097593, slugNation: "united-states", slugState: nil)]
        mockAPIService.mockResult = .success(mockData)

        let expectation = self.expectation(description: "Reload called")
        viewModel.reloadTableView = {
            expectation.fulfill()
        }

        viewModel.fetchPopulationData(for: .nation)

        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(viewModel.populations.count, mockData.count)
        XCTAssertEqual(viewModel.populations.first?.nation, "United States")
    }

    func testFetchPopulationDataForNationFailure() {
        mockAPIService.mockResult = .failure(APIError.invalidResponse)

        let expectation = self.expectation(description: "Show error called")
        viewModel.showError = { error in
            XCTAssertEqual(error, "The operation couldn’t be completed. (CensusUSA.APIError error 0.)")
            expectation.fulfill()
        }

        viewModel.fetchPopulationData(for: .nation)

        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(viewModel.populations.isEmpty)
    }

    func testFilterPopulationByYear() {

        let mockData = [
            PopulationData(idNation: nil, idState: "04000US01", nation: nil, state: "Alabama", idYear: 2022, year: "2022", population: 5028092, slugNation: nil, slugState: "alabama"),
            PopulationData(idNation: nil, idState: "04000US02", nation: nil, state: "Alaska", idYear: 2022, year: "2022", population: 734821, slugNation: nil, slugState: "alaska"),
        ]
        viewModel.populations = mockData

        viewModel.fetchFilterPopulation(year: "2022")

        XCTAssertEqual(viewModel.populations[0].population, mockData[0].population)
        XCTAssertEqual(viewModel.populations[0].year, mockData[0].year)
    }
}
