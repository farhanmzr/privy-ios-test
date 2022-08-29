//
//  User.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 24/06/22.
//

import Foundation

// MARK: - User
struct User: Codable {
  let id, phone, userStatus, userType: String
  let sugarID, country: String
  let latlong: JSONNull
  let userDevice: UserDevice
  
  enum CodingKeys: String, CodingKey {
    case id, phone
    case userStatus = "user_status"
    case userType = "user_type"
    case sugarID = "sugar_id"
    case country, latlong
    case userDevice = "user_device"
  }
}
