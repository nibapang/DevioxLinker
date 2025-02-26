//
//  SignUpRequest.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

import Foundation

struct DevioxSignUpRequest: Codable {
    let first_name: String
    let email: String
    let password: String
    let password_confirmation: String
}
