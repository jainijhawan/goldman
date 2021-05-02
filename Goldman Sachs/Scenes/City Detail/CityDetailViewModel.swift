//
//  CityDetailViewModel.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 02/05/21.
//

import Foundation

protocol CityDetailViewModelType {
  func getWeatherDataForCity(completion: @escaping (CityWeatherModel) -> Void)
  func saveCityToDatabse()
}

class CityDetailViewModel: CityDetailViewModelType {
  
  let interactor: CityDetailInteractorType
  let cityName: String
  let persistenceService: PersistenceServiceType
  
  init(_ interactor: CityDetailInteractorType,
       _ cityName: String,
       _ persistenceService: PersistenceServiceType) {
    self.interactor = interactor
    self.cityName = cityName
    self.persistenceService = persistenceService
  }
  
  func getWeatherDataForCity(completion: @escaping (CityWeatherModel) -> Void) {
    interactor.getWeatherDataForCity(cityName) { (cityWeatherModel) in
      guard let model = cityWeatherModel else { return }
      completion(model)
    }
  }
  
  func saveCityToDatabse() {
    persistenceService.saveCity(name: cityName)
  }
}
