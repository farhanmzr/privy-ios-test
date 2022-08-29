//
//  UserDevice.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 24/06/22.
//

import Foundation

// MARK: - UserDevice
struct UserDevice: Codable {
  let deviceToken, deviceType, deviceStatus: String
  
  enum CodingKeys: String, CodingKey {
    case deviceToken = "device_token"
    case deviceType = "device_type"
    case deviceStatus = "device_status"
  }
}
