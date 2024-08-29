//
//  ApiService.swift
//  CensusUSA
//
//  Created by Arthur Conforti on 28/08/2024.
//

import Alamofire

enum APIError: Error {
    case invalidResponse
    case noData
    case failedRequest
}

protocol APIServiceProtocol {
    func fetchNationPopulation(completion: @escaping (Result<[PopulationData], APIError>) -> Void)
    func fetchStatePopulation(year: String?, completion: @escaping (Result<[PopulationData], APIError>) -> Void)
}

class APIService: APIServiceProtocol {
    
    public var baseURL = "https://datausa.io/api/data"
    
    func fetchNationPopulation(completion: @escaping (Result<[PopulationData], APIError>) -> Void) {
        let url = "\(baseURL)?drilldowns=Nation&measures=Population"
        AF.request(url).responseDecodable(of: APIResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                let populationData = apiResponse.data
                completion(.success(apiResponse.data))
            case .failure(let error):
                completion(.failure(.failedRequest))
            }
        }
    }
    
    
    func fetchStatePopulation(year: String? = "latest", completion: @escaping (Result<[PopulationData], APIError>) -> Void) {
        let url = "\(baseURL)?drilldowns=State&measures=Population&year=\(year ?? "")"
        AF.request(url).responseDecodable(of: APIResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                let populationData = apiResponse.data
                completion(.success(apiResponse.data))
            case .failure(let error):
                completion(.failure(.failedRequest))
            }
        }
    }
}

