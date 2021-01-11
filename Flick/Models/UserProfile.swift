//
//  UserProfile.swift
//  Flick
//
//  Created by Lucy Xu on 7/3/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    var id: Int
    var username: String
    var name: String
    var profilePic: String?
    var bio: String?
    var phoneNumber: String?
    var socialIdToken: String?
    var socialIdTokenType: String?
    var ownerLsts: [SimpleMediaList]?
    var collabLsts: [SimpleMediaList]?
    var numMutualFriends: Int?
    var friendStatus: FriendStatus?
}

enum FriendStatus: String, Codable {
    case friends = "friends"
    case incomingRequest = "incoming request"
    case notFriends = "not friends"
    case outgoingRequest = "outgoing request"
}
