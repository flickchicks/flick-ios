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
    var isSpoiler: Bool
    var numLikes: Int
    var likers: [Likers]
    var owner: CommentUser
    var message: String

}

struct CommentUser: Codable {

    var id: Int
    var username: String
    var firstName: String
    var lastName: String
    var profilePic: ProfilePicture

}

struct Likers: Codable {
    var liker: CommentUser
    var createdAt: String
}
