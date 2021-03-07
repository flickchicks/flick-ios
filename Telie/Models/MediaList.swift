//
//  MediaList.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct SimpleMediaList: Codable {
    var id: Int
    var name: String
    var isPrivate: Bool
    var owner: UserProfile
    var collaborators: [UserProfile] // Simple collaborator
    var shows: [SimpleMedia] // Simple Media
}

struct MediaList: Codable {
    var id: Int
    var name: String
    var pic: String?
    var isSaved: Bool
    var description: String?
    var isPrivate: Bool
    var isWatchLater: Bool
    var collaborators: [UserProfile]
    var owner: UserProfile
    var shows: [SimpleMedia]
    var tags: [Tag]
    var numLikes: Int
    var hasLiked: Bool
    var likers: [UserProfile]
}

struct NotificationMediaList: Codable {
    var id: Int
    var name: String
    var pic: String?
    var isSaved: Bool
    var isPrivate: Bool
    var isWatchLater: Bool
}
