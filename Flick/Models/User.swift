//
//  User.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

//class User: NSObject, Codable {
//
//    var username: String
//    var firstName: String
//    var lastName: String
//    var profilePic: String?
//    var socialIdToken: String
//    var socialIdTokenType: String
//
//    init(username: String, firstName: String, lastName: String, profilePic: String, socialIdToken: String, socialIdTokenType: String) {
//        self.username = username
//        self.firstName = firstName
//        self.lastName = lastName
//        self.profilePic = profilePic
//        self.socialIdToken = socialIdToken
//        self.socialIdTokenType = socialIdTokenType
//    }
//
//}

struct User: Codable {

    var username: String
    var firstName: String
    var lastName: String
    var profilePic: String?
    var socialIdToken: String
    var socialIdTokenType: String

}
