//
//  FriendRequest.swift
//  Flick
//
//  Created by Lucy Xu on 1/8/21.
//  Copyright © 2021 flick. All rights reserved.
//

struct BackendFriendRequest: Codable {
    var fromUser: UserProfile
    var created: String
    var rejected: Bool?
    var viewed: Bool?
}
