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
    var id: String
    var isSpoiler: Bool
    var numLikes: Int
    var likers: [String]
    var owner: CommentUser
    var message: String

}

struct CommentUser: Codable {

    var userId: String
    var username: String
    var firstName: String
    var lastName: String
    var profileId: String
    var profilePic: ProfilePicture

}
