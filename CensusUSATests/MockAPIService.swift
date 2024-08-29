//
//  MockAPIService.swift
//  CensusUSATests
//
//  Created by Arthur Conforti on 29/08/2024.
//
import Foundation
@testable import CensusUSA

class MockAPIService: APIServiceProtocol {

    var mockResult: Result<[PopulationData], APIError>?

    func fetchNationPopulation(completion: @escaping (Result<[PopulationData], APIError>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }

    func fetchStatePopulation(year: String? = nil, completion: @escaping (Result<[PopulationData], APIError>) -> Void) {
        if let result = mockResult {
            completion(result)
        }
    }
}
