//
//  Hit.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

import Foundation

struct DevioxHit: Codable {
    let videos: DevioxVideos
    enum CodingKeys: String, CodingKey {
        case videos
    }
}
