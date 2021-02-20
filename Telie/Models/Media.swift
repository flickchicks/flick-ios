//
//  Media.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct SimpleMedia: Codable {
    var id: Int
    var title: String
    var posterPic: String?
}

struct Media: Codable {
    var id: Int
    var title: String
    var posterPic: String?
    var directors: String?
    var isTv: Bool
    var dateReleased: String?
    var providers: [Provider]?
    var status: String?
    var language: String?
    var duration: String?
    var plot: String?
    var tags: [Tag]?
    var seasons: Int?
    var audienceLevel: String?
    var imdbRating: Int?
    var tomatoRating: Int?
    var friendsRating: Int?
    var userRating: Int?
    var comments: [Comment]?
    var platforms: [String]?
    var keywords: [String]?
    var cast: String?
}