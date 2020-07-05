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
    var shows: [Media]?
    var collaborators: [UserProfile]
    var timestamp: String
    var tags: [String]
    var media: [Media]
    var owner: UserProfile

}

struct UserMediaList: Codable {

    var lstId: String
    var lstName: String
    var lstPic: String?
    var isFavorite: Bool
    var isPrivate: Bool
    var isWatched: Bool
    var shows: [Media]

}

