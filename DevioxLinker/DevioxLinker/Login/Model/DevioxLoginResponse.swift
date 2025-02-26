//
//  LoginResponse.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import Foundation

struct DevioxLoginResponse: Codable {
    let status: Bool
    let data: DevioxUserDataLogin
    let message: String
}
