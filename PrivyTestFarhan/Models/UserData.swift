//
//  UserData.swift
//  PrivyTestFarhan
//
//  Created by Farhan Mazario on 25/06/22.
//

import Foundation

// MARK: - UserData
struct UserData: Codable {
    let id: String?
    let name: String?
    let level: Int?
    let age: Int?
    let birthday: String?
    let gender: String?
    let zodiac: String?
    let hometown, bio: String?
    let latlong: String?
    let education: Education
    let career: Career
    let userPictures: [String]?
    let userPicture: String?
    let coverPicture: CoverPicture

    enum CodingKeys: String, CodingKey {
        case id, name, level, age, birthday, gender, zodiac, hometown, bio, latlong, education, career
        case userPictures = "user_pictures"
        case userPicture = "user_picture"
        case coverPicture = "cover_picture"
    }
    
}

// MARK: - Career
struct Career: Codable {
    let companyName: String?
    let startingFrom, endingIn: String?

    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case startingFrom = "starting_from"
        case endingIn = "ending_in"
    }
}

// MARK: - CoverPicture
struct CoverPicture: Codable {
    let url: String?
}

// MARK: - Education
struct Education: Codable {
    let schoolName: String?
    let graduationTime: String?

    enum CodingKeys: String, CodingKey {
        case schoolName = "school_name"
        case graduationTime = "graduation_time"
    }
}
