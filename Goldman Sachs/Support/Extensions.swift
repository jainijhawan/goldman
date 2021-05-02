//
//  Extensions.swift
//  Goldman Sachs
//
//  Created by Jai Nijhawan on 01/05/21.
//

import Foundation

extension Double {
  func getTempInCelcius() -> String {
    return String(format: "%.0f", self - 273.15)
  }
}

extension Date {
  func dayOfWeek() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self).capitalized
  }
  func getCurrentDate() -> String {
    let dateFormatterPrint = DateFormatter()
    dateFormatterPrint.dateFormat = "MMM d, yyyy"
    let result = dateFormatterPrint.string(from: self)
    return result
  }
}

extension Notification.Name {
  static let onDatabaseUpdate = Notification.Name("onDatabaseUpdate")
}
