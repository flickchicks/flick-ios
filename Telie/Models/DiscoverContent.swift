//
//  DiscoverContent.swift
//  Flick
//
//  Created by Lucy Xu on 12/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

struct DiscoverContent: Codable {

    var friendRecommendations: [FriendRecommendation]?
    var friendLsts: [MediaList]?
    var trendingLsts: [MediaList]
    var trendingShows: [SimpleMedia]
    var friendShows: [SimpleMedia]?
    var friendComments: [FriendComment]?
}

struct SimpleMedia2: Codable {
    var id: Int
    var extApiSource: String
    var extApiId: Int
    var title: String
    var posterPic: String?
    var directors: String?
    var isTv: Bool
}

struct FriendRecommendation: Codable {
    let id: Int
    let username: String
    let name: String
    let profilePic: String
    let numMutualFriends: Int
}

struct FriendComment: Codable {

    var createdAt: String
    var id: Int
    var isSpoiler: Bool?
    var numLikes: Int
//    var hasLiked: Bool
//    var isReadable: Bool
    var owner: UserProfile
    var message: String
    var show: SimpleMedia

}
