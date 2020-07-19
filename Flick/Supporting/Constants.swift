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
        static let onlyICanEdit = "Only I can edit"
        static func numCanEdit(num: Int) -> String {
            return "\(num) can edit"
        }
    }

    struct Privacy {
        static let anyoneCanView = "Anyone can view"
        static let onlyICanView = "Only I can view"
    }

    struct UserDefaults {
        static let authorizationToken = "authorizationToken"
        static let user = "user"
    }

}
