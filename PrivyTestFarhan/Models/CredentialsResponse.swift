//
//  CredentialsResponse.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 25/06/22.
//

import Foundation

// MARK: - CredentialsResponse
struct CredentialsResponse: Codable {
    let data: CredentialsData
}

// MARK: - DataClass
struct CredentialsData: Codable {
    let user: UserData
}
