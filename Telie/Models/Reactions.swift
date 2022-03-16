//
//  Reactions.swift
//  Telie
//
//  Created by Haiying W on 3/16/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import Foundation

struct ReactionsForMedia: Codable {
    var id: Int
    var seasonDetails: [ReactionSeasonDetail]
}

struct ReactionSeasonDetail: Codable {
    var id: Int
    var episodeDetails: [EpisodeDetail]
}
