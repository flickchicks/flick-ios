//
//  Constants.swift
//  Flick
//
//  Created by Lucy Xu on 7/4/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct Constants {

    struct Collaboration {
        static func numCanEdit(num: Int) -> String {
            return "\(num) can edit"
        }
    }

    struct Privacy {
        static let privateList = "Private"
        static let publicList = "Public"
    }

    struct UserDefaults {
        static let authorizationToken = "authorizationToken"
        static let didPromptPermission = "didPromptPermission"
        static let userId = "userId"
        static let userName = "userId"
        static let userUsername = "userUsername"
        static let userProfilePicUrl = "userProfilePicUrl"
        static let userFriends = "userFriends"
        static let userBio = "userBio"
    }

    struct User {
        static let defaultImage = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"
    }

}
