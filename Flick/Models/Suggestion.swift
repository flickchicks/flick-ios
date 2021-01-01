//
//  Suggestion.swift
//  Flick
//
//  Created by Haiying W on 12/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

struct Suggestion: Codable {
//    var toUser: UserProfile
    var fromUser: UserProfile
    var show: Media
    var message: String
}
