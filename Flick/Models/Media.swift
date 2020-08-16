//
//  Media.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct Media: Codable {
    var id: Int
    var title: String
    var posterPic: String
    var directors: String?
    var isTv: Bool
    var dateReleased: String?
    var status: String?
    var language: String?
    var duration: String?
    var plot: String
    var tags: [MediaTag]
    var seasons: String?
    var audienceLevel: String?
    var imbdRating: Int?
    var tomatoRating: Int?
    var friendsRating: Int?
    var userRating: Int?
    var comments: [String]
    var platforms: [String]?
    var keywords: [String]?
    var cast: String
}

struct Tag: Codable {
    var tagId: String
    var tag: String
}

struct MediaTag: Codable {
    var id: Int
    var name: String
}
