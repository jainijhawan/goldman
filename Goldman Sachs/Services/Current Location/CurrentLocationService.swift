//
//  CurrentLocationService.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 30/04/21.
//

import Foundation

protocol CurrentLocationServiceType {
  func getWeatherDataForCurrentLocation(lat:Double,
                                        lon: Double,
                                        completion: @escaping (Result<WeatherDataModel,
                                                                      RequestErrors>) -> Void)
}

class CurrentLocationService: CurrentLocationServiceType {
  let network: NetworkType
  
  init(_ network: NetworkType) {
    self.network = network
  }
  
  func getWeatherDataForCurrentLocation(lat:Double,
                                        lon: Double,
                                        completion: @escaping (Result<WeatherDataModel,
                                                                      RequestErrors>) -> Void) {
    guard let coordinatesURL = URLGenerator.urlForCoordinates(lat,lon) else {
      completion(.failure(.networkError(.badURL)))
      return
    }
    
    network.performNetworkGetCallWith(url: coordinatesURL) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
        #if DEBUG
        fatalError(error.localizedDescription)
        #endif
      case .success(let data):
        let data = try? JSONDecoder().decode(WeatherDataModel.self,
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
