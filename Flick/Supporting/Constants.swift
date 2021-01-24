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
    }

}
