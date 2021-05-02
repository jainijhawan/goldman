//
//  PathGenerator.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 30/04/21.
//

import Foundation

enum APIUrlPath: String {
  case oneCall = "/data/2.5/onecall"
  case cityName = "/data/2.5/weather"
  case autoComplete = "/maps/api/place/autocomplete/json"
}

enum HTTPScheme: String {
  case https = "https"
}

enum APIHostUrl: String {
  case openWeatherMap = "api.openweathermap.org"
  case google = "maps.googleapis.com"
}
