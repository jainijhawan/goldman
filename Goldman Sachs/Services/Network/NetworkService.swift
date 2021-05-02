//
//  NetworkService.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 30/04/21.
//

import Foundation

protocol NetworkType {
  func performNetworkGetCallWith(url: URL,
                                 completion: @escaping (Result<Data, RequestErrors>) -> Void)
}

class Network: NetworkType {
  
  func performNetworkGetCallWith(url: URL,
                                 completion: @escaping (Result<Data, RequestErrors>) -> Void) {
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let data = data {
        completion(.success(data))
      } else if error != nil {
        completion(.failure(.networkError(.requestFailed)))
      } else {
        completion(.failure(.networkError(.unknown)))
      }
    }.resume()
  }
}
