//
//  URLGenerator.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 30/04/21.
//

import Foundation

class URLGenerator {
  static func urlForCoordinates(_ lat: Double,
                                _  lon: Double) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = HTTPScheme.https.rawValue
    urlComponents.host = APIHostUrl.openWeatherMap.rawValue
    urlComponents.path = APIUrlPath.oneCall.rawValue
    urlComponents.queryItems = [
      URLQueryItem(name: "lat", value: String(lat)),
      URLQueryItem(name: "lon", value: String(lon)),
      URLQueryItem(name: "appid", value: APIKEYS.OPENWEATHERAPIKEY.rawValue)
    ]
    guard let urlString = urlComponents.url?.absoluteString,
          let url = URL(string: urlString) else {
      return nil
    }
    return url
  }
  
  static func urlForCityName(name: String) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = HTTPScheme.https.rawValue
    urlComponents.host = APIHostUrl.openWeatherMap.rawValue
    urlComponents.path = APIUrlPath.cityName.rawValue
    urlComponents.queryItems = [
      URLQueryItem(name: "q", value: name),
      URLQueryItem(name: "appid", value: APIKEYS.OPENWEATHERAPIKEY.rawValue)
    ]
    guard let urlString = urlComponents.url?.absoluteString,
          let url = URL(string: urlString) else {
      return nil
    }
    return url
  }
  
  static func urlForAutoComplete(_ input: String) -> URL? {
    var urlComponents = URLComponents()
    urlComponents.scheme = HTTPScheme.https.rawValue
    urlComponents.host = APIHostUrl.google.rawValue
    urlComponents.path = APIUrlPath.autoComplete.rawValue
    urlComponents.queryItems = [
      URLQueryItem(name: "types", value: "(cities)"),
      URLQueryItem(name: "input", value: input),
      URLQueryItem(name: "key", value: APIKEYS.GOOGLEAUTOCOMPLTE.rawValue)
    ]
    guard let urlString = urlComponents.url?.absoluteString,
          let url = URL(string: urlString) else {
      return nil
    }
    return url
  }
}
