//
//  PopulationData.swift
//  CensusUSA
//
//  Created by Arthur Conforti on 28/08/2024.
//

import Foundation

struct APIResponse: Codable {
    let data: [PopulationData]
    let source: [SourceData]
}

struct SourceData: Codable {
    let measures: [String]
    let annotations: Annotations
    let name: String
    let substitutions: [String]
}

struct Annotations: Codable {
    let sourceName: String
    let sourceDescription: String
    let datasetName: String
    let datasetLink: String
    let tableId: String
    let topic: String
    let subtopic: String

    enum CodingKeys: String, CodingKey {
        case sourceName = "source_name"
        case sourceDescription = "source_description"
        case datasetName = "dataset_name"
        case datasetLink = "dataset_link"
        case tableId = "table_id"
        case topic
        case subtopic
    }
}

struct PopulationData: Codable {
    let idNation: String?
    let idState: String?
    let nation: String?
    let state: String?
    let idYear: Int
    let year: String
    let population: Int
    let slugNation: String?
    let slugState: String?

    enum CodingKeys: String, CodingKey {
        case idNation = "ID Nation"
        case idState = "ID State"
        case nation = "Nation"
        case state = "State"
        case idYear = "ID Year"
        case year = "Year"
        case population = "Population"
        case slugNation = "Slug Nation"
        case slugState = "Slug State"
    }
}
