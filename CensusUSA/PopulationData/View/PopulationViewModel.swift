//
//  PopulationViewModel.swift
//  CensusUSA
//
//  Created by Arthur Conforti on 28/08/2024.
//

import Foundation

class PopulationViewModel {
    var apiService: APIServiceProtocol = APIService()
    var populations: [PopulationData] = []
    
    var reloadTableView: (() -> Void)?
    var showError: ((String) -> Void)?
    var flagType: PopulationType?
    var flagYear: String?
    var isAscending: Bool = true
    
    // MARK: Fetchs Datas
    
    func fetchPopulationData(for type: PopulationType) {
        flagType = type
        flagYear = "latest"
        switch type {
        case .nation:
            apiService.fetchNationPopulation { [weak self] result in
                self?.handleResult(result)
            }
        case .state:
            apiService.fetchStatePopulation(year: flagYear) { [weak self] result in
                self?.handleResult(result)
            }
        }
    }
    
    func fetchFilterPopulation(year: String) {
        flagType = .state
        flagYear = year
        apiService.fetchStatePopulation(year: year, completion: { [weak self] result in
            self?.handleResult(result)
        })
    }
    
    private func handleResult(_ result: Result<[PopulationData], APIError>) {
        switch result {
        case .success(let data):
            populations = data
            reloadTableView?()
        case .failure(let error):
            showError?(error.localizedDescription)
        }
    }
    
    func sortPopulationData() {
        populations.sort { isAscending ? $0.population < $1.population : $0.population > $1.population }
    }

}

public enum PopulationType {
    case nation
    case state
}

