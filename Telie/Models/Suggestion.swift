//
//  Suggestion.swift
//  Flick
//
//  Created by Haiying W on 12/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

struct Suggestion: Codable {
    var id: Int
//    var toUser: UserProfile
    var fromUser: UserProfile
    var show: Media
    var message: String
    var createdAt: String
    var updatedAt: String
    var hasLiked: Bool?
}
