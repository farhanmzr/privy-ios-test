//
//  RegisterResponse.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 24/06/22.
//

import Foundation

// MARK: - RegisterResponse
struct RegisterResponse: Codable {
    let data: RegisterData
}

// MARK: - DataClass
struct RegisterData: Codable {
    let user: User
}
