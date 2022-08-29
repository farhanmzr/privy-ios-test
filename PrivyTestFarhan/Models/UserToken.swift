//
//  UserToken.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 25/06/22.
//

import Foundation

// MARK: - UserToken
struct UserToken: Codable {
    let accessToken, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
