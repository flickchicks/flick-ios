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
    var collaborators: [String]
    var timestamp: String
    var tags: [String]
    var media: [Media]

}

