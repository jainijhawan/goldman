//
//  SearchCityNameDataModel.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 01/05/21.
//

import Foundation
// MARK: - CountryModel

struct SearchLocationModel: Codable {
  var predictions: [Prediction]
  var status: String
}

// MARK: - Prediction
struct Prediction: Codable {
  var description: String
  var structuredFormatting: StructuredFormatting
  enum CodingKeys: String, CodingKey {
    case description = "description"
    case structuredFormatting = "structured_formatting"
  }
}

// MARK: - StructuredFormatting
struct StructuredFormatting: Codable {
  var mainText: String
  enum CodingKeys: String, CodingKey {
    case mainText = "main_text"
  }
}
