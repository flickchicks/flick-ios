//
//  MediaList.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct MediaList: Codable {

    var lstId: String
    var lstName: String
    var lstPic: String // note
    var isPrivate: Bool
    var isFavorite: Bool
    var isWatched: Bool
    var shows: [Show]?
    var collaborators: [String]
    var timestamp: String
    var tags: [String]
    var media: [Media]

}

struct Show: Codable {
    var id: Int
    var title: String
    var posterPic: String
    var directors: String
    var isTv: Bool
    var dateReleased: String
    var status: String
    var language: String
    var duration: String
    var plot: String
    var tags: [Tag]
    var seasons: String?
    var audienceLevel: String?
    var imbdRating: Int?
    var friendsRating: Int?
    var platforms: [String]?
    var keywords: [String]?
    var cast: String
}

struct Tag: Codable {
    var tagId: String
    var tag: String
}
