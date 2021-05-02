//
//  CurrentLocationInteractor.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 30/04/21.
//

import Foundation
import CoreData

protocol CurrentLocationInteractorType {
  func getDataForCurrentLocation(lat: Double,
                                 lon: Double,
                                 completion: @escaping (CurrentLocationDataModel?) -> Void)
  func getWeatherDataForCity(_ city: String,
                             completion: @escaping (CityWeatherModel?) -> Void)
  var onDatabaseUpdate: (([City]) -> Void)? { get set }
  
  func getAllSaveCities() -> [City]
}

class CurrentLocationInteractor: CurrentLocationInteractorType {
  let currectLocationService: CurrentLocationServiceType
  var persistanceService: PersistenceServiceType
  var onDatabaseUpdate: (([City]) -> Void)?
  let cityWeatherService: CityWeatherServiceType
  
  init(_ currentLocationService: CurrentLocationServiceType,
       _ persistanceService: PersistenceServiceType,
       _ cityWeatherService: CityWeatherServiceType) {
    self.currectLocationService = currentLocationService
    self.persistanceService = persistanceService
    self.cityWeatherService = cityWeatherService
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(onDidReceiveData(_:)),
                                           name: .onDatabaseUpdate,
                                           object: nil)
  }
  
  func getDataForCurrentLocation(lat: Double,
                                 lon: Double,
                                 completion: @escaping (CurrentLocationDataModel?) -> Void) {
    currectLocationService
      .getWeatherDataForCurrentLocation(lat: lat,
                                        lon: lon) { (result) in
        switch result {
        case .failure(let error):
          print(error.localizedDescription)
        case .success(let model):
          completion(self.getCurrentLocationDataModel(model))
        }
      }
  }
  
  func getCurrentLocationDataModel(_ model: WeatherDataModel) -> CurrentLocationDataModel? {
    
    guard let minTemp = model.daily.first?.temp.max.getTempInCelcius(),
          let maxTemp = model.daily.first?.temp.min.getTempInCelcius(),
          let id = model.daily.first?.weather.first?.id,
          let text = model.current.weather.first?.weatherDescription.capitalized else {
      return nil
    }
    let temperature = model.current.temp.getTempInCelcius()
    
    return  CurrentLocationDataModel(temperature: temperature,
                                     minTemperature: minTemp,
                                     maximumTemperature: maxTemp,
                                     currentWeatherImageID: id,
                                     dayOfTheWeek: Date().dayOfWeek(),
                                     date:  Date().getCurrentDate(),
                                     weatherText: text,
                                     hourlyDataModel: createHoulyDataModel(with: model))
  }
  
  func createHoulyDataModel(with model: WeatherDataModel) -> [HourlyWeatherCollectionViewCellModel] {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "ha"
    var models = [HourlyWeatherCollectionViewCellModel]()
    for index in 0...24 {
      let date = Date(timeIntervalSince1970: TimeInterval(model.hourly[index].dt))
      let timeString = dateFormatterPrint.string(from: date)
      let id = model.hourly[index].weather.first?.id
      let temp = model.hourly[index].temp.getTempInCelcius()
      
      if timeString == "1AM" {
        models.append(HourlyWeatherCollectionViewCellModel(time: "",
                                                           id: 0,
                                                           temperature: "",
                                                           index: index))
      }
      let model = HourlyWeatherCollectionViewCellModel(time: timeString,
                                                       id: id!,
                                                       temperature: temp + "°",
                                                       index: index)
      models.append(model)
    }
    return models
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
  
  func getAllSaveCities() -> [City] {
    persistanceService.getAllSavedCities()
  }
  
  @objc func onDidReceiveData(_ notification: Notification) {
    onDatabaseUpdate?(persistanceService.getAllSavedCities())
  }
}
