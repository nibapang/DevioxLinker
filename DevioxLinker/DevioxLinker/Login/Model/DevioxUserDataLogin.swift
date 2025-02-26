//
//  UserDataLogin.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

import Foundation

struct DevioxUserDataLogin: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let mobile: String
    let loginType: String
    let gender: String
    let dateOfBirth: String
    let emailVerifiedAt: String
    let isBanned: Int
    let isSubscribe: Int
    let status: Int
    let lastNotificationSeen: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String
    let apiToken: String
    let fullName: String
    let isUserExist: Bool
    let profileImage: String
    let media: [String] // Assuming media is an array of strings (URLs or identifiers)
    let planDetails: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case mobile
        case loginType = "login_type"
        case gender
        case dateOfBirth = "date_of_birth"
        case emailVerifiedAt = "email_verified_at"
        case isBanned = "is_banned"
        case isSubscribe = "is_subscribe"
        case status
        case lastNotificationSeen = "last_notification_seen"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case apiToken = "api_token"
        case fullName = "full_name"
        case isUserExist = "is_user_exist"
        case profileImage = "profile_image"
        case media
        case planDetails = "plan_details"
    }

    // Custom Decoder to handle null values strictly
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        email = try container.decode(String.self, forKey: .email) // Required field
        mobile = try container.decodeIfPresent(String.self, forKey: .mobile) ?? ""
        loginType = try container.decodeIfPresent(String.self, forKey: .loginType) ?? ""
        gender = try container.decodeIfPresent(String.self, forKey: .gender) ?? ""
        dateOfBirth = try container.decodeIfPresent(String.self, forKey: .dateOfBirth) ?? ""
        emailVerifiedAt = try container.decodeIfPresent(String.self, forKey: .emailVerifiedAt) ?? ""
        isBanned = try container.decode(Int.self, forKey: .isBanned)
        isSubscribe = try container.decode(Int.self, forKey: .isSubscribe)
        status = try container.decode(Int.self, forKey: .status)
        lastNotificationSeen = try container.decodeIfPresent(String.self, forKey: .lastNotificationSeen) ?? ""
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        deletedAt = try container.decodeIfPresent(String.self, forKey: .deletedAt) ?? ""
        apiToken = try container.decode(String.self, forKey: .apiToken) // Required field
        fullName = try container.decode(String.self, forKey: .fullName)
        isUserExist = try container.decode(Bool.self, forKey: .isUserExist)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
        media = try container.decodeIfPresent([String].self, forKey: .media) ?? []
        planDetails = try container.decodeIfPresent(String.self, forKey: .planDetails) ?? ""
    }
}
