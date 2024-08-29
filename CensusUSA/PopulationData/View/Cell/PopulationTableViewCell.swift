//
//  PopulationTableViewCell.swift
//  CensusUSA
//
//  Created by Arthur Conforti on 29/08/2024.
//

import UIKit

class PopulationTableViewCell: UITableViewCell {
    
    // MARK: Outlets Config
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initializer for the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure the cell's UI elements and constraints
    private func setupCell() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            // Constraints for nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: numberLabel.leadingAnchor, constant: -8),
            
            // Constraints for numberLabel
            numberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            numberLabel.widthAnchor.constraint(equalToConstant: 100) // Fixed width for number label
        ])
    }
    
    // MARK: Configure the cell with data
    func configure(population: PopulationData?, flagType: PopulationType) {
        nameLabel.text = flagType == .nation ? population?.year : population?.state
        let populationInMillions = Double(population?.population ?? 0) / 1_000_000
        let roundedPopulation = round(populationInMillions * 10) / 10
        numberLabel.text = "\(roundedPopulation)M"
    }
}
