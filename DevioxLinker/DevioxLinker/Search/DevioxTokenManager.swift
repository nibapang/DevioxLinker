//
//  TokenManager.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import Foundation

class DevioxTokenManager {
    static let shared = DevioxTokenManager()
    private let defaults = UserDefaults.standard
    private let tokenKey = "remaining_tokens"
    
    private init() {
        // Initialize with 10 tokens if first launch
        if defaults.integer(forKey: tokenKey) == 0 {
            defaults.set(10, forKey: tokenKey)
        }
    }
    
    var remainingTokens: Int {
        return defaults.integer(forKey: tokenKey)
    }
    
    func useToken() {
        let current = remainingTokens
        if current > 0 {
            defaults.set(current - 1, forKey: tokenKey)
        }
    }
    
    func addTokens(_ count: Int) {
        let current = remainingTokens
        defaults.set(current + count, forKey: tokenKey)
    }
}
