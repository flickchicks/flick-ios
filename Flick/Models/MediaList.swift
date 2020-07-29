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
    var lstPic: String?
    var isSaved: Bool
    var isPrivate: Bool
    var isWatchLater: Bool
    var collaborators: [UserProfile]
    var owner: UserProfile
    var shows: [Media]
//    var timestamp: String?
    var tags: [Tag]

}
