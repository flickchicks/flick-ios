//
//  DiscoverContent.swift
//  Flick
//
//  Created by Lucy Xu on 12/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

struct DiscoverContent: Codable {
    var trendingMovies: [SimpleMedia]
    var trendingTvs: [SimpleMedia]
    var trendingAnimes: [SimpleMedia]
}
