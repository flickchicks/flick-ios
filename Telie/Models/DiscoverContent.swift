//
//  DiscoverContent.swift
//  Flick
//
//  Created by Lucy Xu on 12/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

struct DiscoverContent: Codable {
    var friendRecommendations: [FriendRecommendation]
    var friendLsts: [MediaList]
    var trendingLsts: [MediaList]
    var trendingShows: [SimpleMedia]
    var friendShows: [SimpleMedia]
    var friendComments: [Comment]
}

struct FriendRecommendation: Codable {
    let id: Int
    let username: String
    let name: String
    let profilePic: String?
    let profilePicUrl: String?
    let numMutualFriends: Int
}
