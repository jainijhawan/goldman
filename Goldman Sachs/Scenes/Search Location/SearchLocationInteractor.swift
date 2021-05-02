//
//  SearchLocationInteractor.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 02/05/21.
//

import Foundation

protocol SearchLocationInteractorType {
  func performAutoCompleteSearch(with input: String,
                                 completion: @escaping (SearchLocationModel) -> Void)
}

class SearchLocationInteractor: SearchLocationInteractorType{
  
  let searchLocationService: SearchCityLocationServiceType
  
  init(_ searchLocationService: SearchCityLocationServiceType) {
    self.searchLocationService = searchLocationService
  }
  
  func performAutoCompleteSearch(with input: String,
                                 completion: @escaping (SearchLocationModel) -> Void) {
    searchLocationService.getAutoCompleteCityNames(input: input) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
      case .success(let model):
        completion(model)
      }
    }
  }
}
