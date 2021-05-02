//
//  CurrentLocationViewModel.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 30/04/21.
//

import Foundation

struct CurrentLocationDataModel {
  let temperature: String
  let minTemperature: String
  let maximumTemperature: String
  let currentWeatherImageID: Int
  let dayOfTheWeek: String
  let date: String
  let weatherText: String
  let hourlyDataModel: [HourlyWeatherCollectionViewCellModel]
}

enum CurrentLocationVCCells: String {
  case hourly = "HourlyWeatherCollectionViewCell"
  case city = "CityCollectionViewCell"
}
protocol CurrentLocationViewModelType {
  func getWeatherDataFor(lat: Double,
                         lon: Double,
                         completion: @escaping () -> Void)  
  var getDataModel: CurrentLocationDataModel? { get }
  var getSavedCitiesDataModel: [CityCollectionViewCellModel] { get }
  var onDatabaseUpdate: (() -> Void)? { get set }
}

class CurrentLocationViewModel: CurrentLocationViewModelType {
  
  var interactor: CurrentLocationInteractorType
  
  var dataModel: CurrentLocationDataModel?
  
  var hourlyCellsDataModel: [HourlyWeatherCollectionViewCellModel]?
  
  var savedCitiesDataModel = [CityCollectionViewCellModel]()
  
  var onDatabaseUpdate: (() -> Void)?
  
  var getDataModel: CurrentLocationDataModel? {
    return dataModel
  }
  var getSavedCitiesDataModel: [CityCollectionViewCellModel] {
    return savedCitiesDataModel
  }
  
  init(_ interactor: CurrentLocationInteractorType) {
    self.interactor = interactor
    onbserveChangesInCoredata()
    getDataForAllSavedCities(cityArray: interactor.getAllSaveCities())
  }
  
  func getWeatherDataFor(lat: Double,
                         lon: Double,
                         completion: @escaping () -> Void) {
    interactor.getDataForCurrentLocation(lat: lat, lon: lon) { (model) in
      guard let dataModel = model else { return }
      self.dataModel = dataModel
      completion()
    }
  }
  
  func onbserveChangesInCoredata() {
    self.interactor.onDatabaseUpdate = { [weak self] cityArray in
      if let strongSelf = self {
        strongSelf.getDataForLatestAddedCity(cityArray.last?.name ?? "")
      }
    }
  }
  
  func getDataForLatestAddedCity(_ city: String) {
    interactor.getWeatherDataForCity(city) { (cityWeatherModel) in
      self.savedCitiesDataModel.append(CityCollectionViewCellModel(cityName: cityWeatherModel?.name ?? "",
                                                   temperature: cityWeatherModel?.main.temp.getTempInCelcius() ?? "",
                                                   id: cityWeatherModel?.weather.first?.id ?? 0))
      self.onDatabaseUpdate?()
    }
  }
  
  func getDataForAllSavedCities(cityArray: [City]) {
    var cityModel = [CityCollectionViewCellModel]()
    
    cityArray.forEach { (city) in
      cityModel.removeAll()
      interactor.getWeatherDataForCity(city.name ?? "") { (cityWeatherModel) in
        cityModel.append(CityCollectionViewCellModel(cityName: cityWeatherModel?.name ?? "",
                                                     temperature: cityWeatherModel?.main.temp.getTempInCelcius() ?? "",
                                                     id: cityWeatherModel?.weather.first?.id ?? 0))
        if cityArray.count == cityModel.count {
          self.savedCitiesDataModel = cityModel
          self.onDatabaseUpdate?()
        }
      }
    }
  }
}

