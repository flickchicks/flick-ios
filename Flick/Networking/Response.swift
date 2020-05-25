//
//  Response.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct Response<T: Codable>: Codable {

    var data: T
    var success: Bool

}

struct UsernamesDataResponse: Codable {

    var usernames: [String]

}

struct FriendsDataResponse: Codable {

    var friends: [User]

}

struct IdResponse: Codable {

    var id: String

}

struct MediaListsResponse: Codable {

    var lists: [MediaList]

}
