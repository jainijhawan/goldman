//
//  Errors.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 30/04/21.
//

import Foundation

enum NetworkError: String, Error {
    case badURL, requestFailed, unknown
}

enum RequestErrors: Error {
  case networkError(NetworkError)
  case mappingError
}
