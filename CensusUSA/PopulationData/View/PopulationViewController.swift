//
//  PopulationViewController.swift
//  CensusUSA
//
//  Created by Arthur Conforti on 28/08/2024.
//
import UIKit

class PopulationViewController: UIViewController {
        
    var viewModel: PopulationViewModel?
    var coordinator: AppCoordinator?
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    
    // MARK:  Load UI

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Census Nation"
        setupNavigationBar()
        setupTableView()
        setupLoadingIndicator()
        setupUI()
        setupBindings()
        loadInitialData()
    }
    
    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(showFilterOptions))
        navigationItem.rightBarButtonItem = filterButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor.primaryRed
        navigationItem.rightBarButtonItem?.isHidden = viewModel?.flagType == .state ? false : true
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PopulationTableViewCell.self, forCellReuseIdentifier: "PopulationCell") // Register the custom cell
    }
    
    private func setupLoadingIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingIndicator)
    }
    
    private func setupBindings() {
        viewModel?.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
        
        viewModel?.showError = { [weak self] error in
            DispatchQueue.main.async {
                self?.loadingIndicator.stopAnimating()
                let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    private func loadInitialData() {
        loadingIndicator.startAnimating()
        coordinator?.showPopulationDetails(for: .nation)
    }
    
    // MARK: Actions UI
    
    @objc private func showFilterOptions() {
        let alert = UIAlertController(title: "Select Year", message: "Choose a year to filter", preferredStyle: .actionSheet)
        
        for year in (2014...2022) {
            let yearAction = UIAlertAction(title: "\(year)", style: .default) { [weak self] _ in
                self?.filterDataByYear(year)
            }
            alert.addAction(yearAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view 
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }

    private func filterDataByYear(_ year: Int) {
        self.loadingIndicator.startAnimating()
        viewModel?.fetchFilterPopulation(year: String(year))
    }

    @objc func toggleSortOrder() {
        viewModel?.isAscending.toggle()
        sortPopulationData()
    }
    
    private func sortPopulationData() {
        viewModel?.sortPopulationData()
        tableView.reloadData()
    }
    
    @objc private func nationTapped(_ sender: UIButton) {
        loadingIndicator.startAnimating()
        coordinator?.showPopulationDetails(for: .nation)
        setupNavigationBar()
    }

    @objc private func stateTapped(_ sender: UIButton) {
        loadingIndicator.startAnimating()
        coordinator?.showPopulationDetails(for: .state)
        setupNavigationBar()
    }
    
}

// MARK: TableView

extension PopulationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.populations.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopulationCell", for: indexPath) as! PopulationTableViewCell
        cell.configure(population: viewModel?.populations[indexPath.row], flagType: viewModel?.flagType ?? .nation)
        return cell
    }
}

extension PopulationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createTableHeaderView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
}

// MARK: Setup UI

extension PopulationViewController {
    func setupUI() {
        
        // Setup Header Navigation
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.primaryBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        // Setup TableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
        ])
        
        // Setup LoadingIndicator
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        
        // Setup ToolBar
        
        let bottomToolbar = UIStackView()
        bottomToolbar.distribution = .fillEqually
        bottomToolbar.axis = .horizontal
        bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        bottomToolbar.backgroundColor = UIColor.primaryBlue
        view.addSubview(bottomToolbar)
                
        let leftContainer = UIView()
        bottomToolbar.addArrangedSubview(leftContainer)
                
        let rightContainer = UIView()
        bottomToolbar.addArrangedSubview(rightContainer)
        
        let nationButton = UIButton()
        nationButton.setTitle("Nation", for: .normal)
        nationButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        nationButton.setTitleColor(UIColor.primaryRed, for: .normal)
        nationButton.addTarget(self, action: #selector(nationTapped(_:)), for: .touchUpInside)
        nationButton.translatesAutoresizingMaskIntoConstraints = false
        leftContainer.addSubview(nationButton)
                
        let stateButton = UIButton()
        stateButton.setTitle("States", for: .normal)
        stateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        stateButton.setTitleColor(UIColor.primaryRed, for: .normal)
        stateButton.addTarget(self, action: #selector(stateTapped(_:)), for: .touchUpInside)
        stateButton.translatesAutoresizingMaskIntoConstraints = false
        rightContainer.addSubview(stateButton)
        
        NSLayoutConstraint.activate([
            bottomToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomToolbar.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            nationButton.centerYAnchor.constraint(equalTo: leftContainer.centerYAnchor),
            nationButton.centerXAnchor.constraint(equalTo: leftContainer.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stateButton.centerYAnchor.constraint(equalTo: rightContainer.centerYAnchor),
            stateButton.centerXAnchor.constraint(equalTo: rightContainer.centerXAnchor)
        ])
    }
    
    func createTableHeaderView() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white

        let nameLabel = UILabel()
        nameLabel.text = viewModel?.flagType == .nation ? "Years" : "States in \(viewModel?.flagYear ?? "")"
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(nameLabel)

        let valueLabel = UILabel()
        valueLabel.text = "Population"
        valueLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        valueLabel.textColor = .systemBlue
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        let sortImageView = UIImageView()
        sortImageView.image = UIImage(named: "arrowSort")
        sortImageView.contentMode = .scaleAspectFit
        sortImageView.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [valueLabel, sortImageView])
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(stackView)

        // Add gesture recognizer for sorting
        let sortGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSortOrder))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(sortGesture)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            sortImageView.widthAnchor.constraint(equalToConstant: 20),
            sortImageView.heightAnchor.constraint(equalToConstant: 20)
        ])

        return headerView
    }
}
