//
//  WallPaperModel.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

import Foundation

struct DevioxWallPaperModel: Codable {
    let total: Int
    let totalHits: Int
    let hits: [Hit]
    
    // MARK: - Hit
    struct Hit: Codable {
        let id: Int
        let pageURL: String
        let type: String
        let tags: String
        let previewURL: String
        let previewWidth: Int
        let previewHeight: Int
        let webformatURL: String
        let webformatWidth: Int
        let webformatHeight: Int
        let largeImageURL: String
        let imageWidth: Int
        let imageHeight: Int
        let imageSize: Int
        let views: Int
        let downloads: Int
        let collections: Int
        let likes: Int
        let comments: Int
        let userID: Int
        let user: String
        let userImageURL: String

        enum CodingKeys: String, CodingKey {
            case id, type, tags
            case pageURL = "pageURL"
            case previewURL, previewWidth, previewHeight
            case webformatURL, webformatWidth, webformatHeight
            case largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, collections, likes, comments
            case userID = "user_id"
            case user
            case userImageURL
        }
    }
}
