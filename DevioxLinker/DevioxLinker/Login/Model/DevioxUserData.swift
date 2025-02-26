//
//  UserData.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

import Foundation

struct DevioxUserData: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    let mobile: String
    let apiToken: String
    let avatar: String
    let loginType: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case username
        case email
        case mobile
        case apiToken = "api_token"
        case avatar
        case loginType = "login_type"
    }

    // Custom Decoder to handle null values strictly
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        email = try container.decode(String.self, forKey: .email) // Required field
        mobile = try container.decodeIfPresent(String.self, forKey: .mobile) ?? ""
        apiToken = try container.decodeIfPresent(String.self, forKey: .apiToken) ?? ""
        avatar = try container.decodeIfPresent(String.self, forKey: .avatar) ?? ""
        loginType = try container.decodeIfPresent(String.self, forKey: .loginType) ?? ""
    }
}
