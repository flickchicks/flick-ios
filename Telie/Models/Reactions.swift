//
//  Reactions.swift
//  Telie
//
//  Created by Haiying W on 3/16/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import Foundation

struct Reaction: Codable {
    var id: Int
    var text: String
    var visibility: Visibility
    var author: UserProfile
}

struct ReactionsForMedia: Codable {
    var id: Int
    var seasonDetails: [SeasonDetail]
}
