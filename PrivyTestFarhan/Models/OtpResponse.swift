//
//  OtpResponse.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 25/06/22.
//

import Foundation

// MARK: - OtpResponse
struct OtpResponse: Codable {
    let data: OtpData
}

// MARK: - DataClass
struct OtpData: Codable {
    let user: UserToken
}
