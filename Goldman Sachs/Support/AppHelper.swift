//
//  AppHelper.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 01/05/21.
//

import Foundation
import CoreLocation
import UIKit

class AppHelper {
  static func reverseGeoCode(lat: Double, lon: Double,
                             completion: @escaping (_ data: String) -> Void) {
    let geocoder = CLGeocoder()
    let location = CLLocation(latitude: lat, longitude: lon)
    
    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
      if error == nil {
        completion(placemarks?.first?.locality ?? "")
      }
    }
  }
  
  static func getImageForCurrentWeatherID(id: Int) -> UIImage? {
    var name = ""
    switch id {
    case 200...202:
      name = "Thunderstorm + Rain"
    case 210...221:
      name = "Thunderstorm"
    case 230...232:
      name = "Thunderstorm + Rain"
    case 300...599:
      name = "Rain"
    case 600...601:
      name = "Snow"
    case 611...622:
      name = "Rain Heavy"
    case 700...799:
      name = "Mist"
    case 800:
      name = "Sun"
    case 801:
      name = "Cloud"
    case 802...899:
      name = "Sun + Cloud"
    default:
      name = "Sun"
    }
    return UIImage(named: name)
  }
}
