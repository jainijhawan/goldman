//
//  CityWeatherModel.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 02/05/21.
//

import Foundation

// MARK: - CityWeatherModel
struct CityWeatherModel: Codable {
  let weather: [Weather]
  let main: Main
  let name: String
}

// MARK: - Main
struct Main: Codable {
  let temp: Double
  
  enum CodingKeys: String, CodingKey {
    case temp
  }
}
