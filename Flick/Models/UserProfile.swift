//
//  UserProfile.swift
//  Flick
//
//  Created by Lucy Xu on 7/3/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct UserProfile: Codable {

    var userId: String
    var username: String
    var firstName: String
    var lastName: String
    var profileId: String
    var profilePic: ProfilePicture?
    var bio: String?
    var phoneNumber: String?
    var socialIdToken: String?
    var socialIdTokenType: String?
    var ownerLsts: [MediaList]?
    var collabLsts: [MediaList]?
}

struct ProfilePicture: Codable {
    var id: Int
    var salt: String
    var kind: String
    var baseUrl: String
    var assetUrls: AssetUrls
    var createdAt: String
    var updatedAt: String
}

struct AssetUrls: Codable {
    var original: String
    var large: String
    var small: String
}
