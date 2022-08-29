//
//  DateExtensions.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 28/06/22.
//

import Foundation

extension Date {
  func dateFormat(format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter.string(from: self)
  }
}
