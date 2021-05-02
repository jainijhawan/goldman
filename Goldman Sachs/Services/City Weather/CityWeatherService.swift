//
//  CityWeatherService.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 02/05/21.
//

import Foundation

protocol CityWeatherServiceType {
  func getWeatherDataFor(cityName: String,
                         completion: @escaping (Result<CityWeatherModel,
                                                       RequestErrors>) -> Void)
}

class CityWeatherService: CityWeatherServiceType {
  let network: NetworkType
  
  init(_ network: NetworkType) {
    self.network = network
  }
  
  func getWeatherDataFor(cityName: String,
                         completion: @escaping (Result<CityWeatherModel,
                                                       RequestErrors>) -> Void) {
    guard let cityNameURL = URLGenerator.urlForCityName(name: cityName) else {
      completion(.failure(.networkError(.badURL)))
      return
    }
    network.performNetworkGetCallWith(url: cityNameURL) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
        #if DEBUG
        fatalError(error.localizedDescription)
        #endif
      case .success(let data):
        let data = try? JSONDecoder().decode(CityWeatherModel.self,
                                             from: data)
        if let weatherDataModel = data {
          completion(.success(weatherDataModel))
        } else {
          completion(.failure(.mappingError))
        }
      }
    }
  }
}
