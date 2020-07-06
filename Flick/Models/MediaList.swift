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
    // Note: Unimplemented for now in backend
    var lstPic: String?
    var isFavorite: Bool
    var isPrivate: Bool
    var isWatched: Bool
    // Note: Change string to user profile later
    var collaborators: [String]
    var owner: UserProfile
    var shows: [Media]?
//    var timestamp: String?
    var tags: [String]?
    
}

