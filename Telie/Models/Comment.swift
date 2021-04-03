//
//  Comment.swift
//  Flick
//
//  Created by Lucy Xu on 7/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct Comment: Codable {
    var createdAt: String
    var id: Int
    var isSpoiler: Bool?
    var numLikes: Int
    var owner: UserProfile
    var message: String
    var show: SimpleMedia?
    var hasLiked: Bool?
    var isReadable: Bool?
}
