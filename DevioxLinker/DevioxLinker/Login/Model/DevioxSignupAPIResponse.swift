//
//  SignupAPIResponse.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import Foundation

struct DevioxSignupAPIResponse: Codable {
    let status: Bool
    let data: DevioxUserData
    let message: String
}
