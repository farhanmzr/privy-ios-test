//
//  ErrorResponse.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 24/06/22.
//

import Foundation

public struct ErrorResponse: Codable {
  
  let error : Bool?
  let message : String?
  let status : Int?
  
  enum CodingKeys: String, CodingKey {
    case error = "error"
    case message = "message"
    case status = "status"
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    error = try values.decodeIfPresent(Bool.self, forKey: .error)
    message = try values.decodeIfPresent(String.self, forKey: .message)
    status = try values.decodeIfPresent(Int.self, forKey: .status)
  }
  
}
