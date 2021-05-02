//
//  CityDetailInteractor.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 02/05/21.
//

import Foundation

protocol CityDetailInteractorType {
  func getWeatherDataForCity(_ city: String,
                             completion: @escaping (CityWeatherModel?) -> Void)
}

class CityDetailInteractor: CityDetailInteractorType {
  
  let cityWeatherService: CityWeatherServiceType
  
  init(_ cityWeatherService: CityWeatherServiceType) {
    self.cityWeatherService = cityWeatherService
  }
  
  func getWeatherDataForCity(_ city: String,
                             completion: @escaping (CityWeatherModel?) -> Void) {
    cityWeatherService.getWeatherDataFor(cityName: city) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let model):
        completion(model)
      }
    }
  }
}
