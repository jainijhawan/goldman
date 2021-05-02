//
//  SearchCityLocationService.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 01/05/21.
//

import Foundation

protocol SearchCityLocationServiceType {
  func getAutoCompleteCityNames(input: String,
                                completion: @escaping (Result<SearchLocationModel,
                                                              RequestErrors>) -> Void)
}

class SearchCityLocationService: SearchCityLocationServiceType {
  let network: NetworkType
  
  init(_ network: NetworkType) {
    self.network = network
  }
  
  func getAutoCompleteCityNames(input: String,
                                completion: @escaping (Result<SearchLocationModel,
                                                              RequestErrors>) -> Void) {
    guard let autoCompleteURL = URLGenerator.urlForAutoComplete(input) else {
      completion(.failure(.networkError(.badURL)))
      return
    }
    
    network.performNetworkGetCallWith(url: autoCompleteURL) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
        #if DEBUG
        fatalError(error.localizedDescription)
        #endif
      case .success(let data):
        let data = try? JSONDecoder().decode(SearchLocationModel.self,
                                             from: data)
        if let searchCityNameModels = data {
          completion(.success(searchCityNameModels))
        } else {
          completion(.failure(.mappingError))
        }
      }
    }
  }
}
