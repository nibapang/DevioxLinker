//
//  VideoModel.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

import Foundation

struct DevioxVideoModel: Codable {
    let total, totalHits: Int
    let hits: [DevioxHit]
}
