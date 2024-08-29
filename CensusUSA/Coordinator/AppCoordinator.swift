//
//  AppCoordinator.swift
//  CensusUSA
//
//  Created by Arthur Conforti on 28/08/2024.
//
import UIKit

class AppCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let populationViewController = PopulationViewController()
        populationViewController.viewModel = PopulationViewModel()
        populationViewController.coordinator = self
        navigationController.pushViewController(populationViewController, animated: true)
    }
    
    func showPopulationDetails(for type: PopulationType) {
        if let populationViewController = navigationController.topViewController as? PopulationViewController {
            populationViewController.viewModel?.fetchPopulationData(for: type)
        }
    }
}
