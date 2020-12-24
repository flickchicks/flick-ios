//
//  DiscoverContent.swift
//  Flick
//
//  Created by Lucy Xu on 12/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

struct DiscoverContent: Codable {
    var trendingMovies: [DiscoverMedia]
    var trendingTvs: [DiscoverMedia]
    var trendingAnimes: [DiscoverMedia]
}

struct DiscoverMedia: Codable {
    var id: Int
    var posterPic: String
    var title: String
}
