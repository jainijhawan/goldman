//
//  SearchLocationViewModel.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 02/05/21.
//

import Foundation

enum SearchLocationVCCells: String {
  case searchLocationCell = "SearchLocationTableViewCell"
}

protocol SearchLocationViewModelType {
  var cityNames: [(description: String, actualName: String)]? { get }
  
  func getDataFor(name input: String,
                  completion: @escaping () -> Void)
}

class SearchLocationViewModel: SearchLocationViewModelType {
  
  let interactor: SearchLocationInteractorType
  
  var cityNames: [(description: String, actualName: String)]?
  
  init(_ interactor: SearchLocationInteractorType) {
    self.interactor = interactor
  }
  
  func getDataFor(name input: String,
                  completion: @escaping () -> Void) {
    interactor.performAutoCompleteSearch(with: input) { (searchModel) in
      self.cityNames = [(description: String, actualName: String)]()
      searchModel.predictions.forEach { (prediction) in
        self.cityNames?.append((description: prediction.description,
                                actualName: prediction.structuredFormatting.mainText))
      }
      completion()
    }
  }
}
