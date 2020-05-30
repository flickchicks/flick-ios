//
//  Media.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct Media: Codable {

    var mediaId: String
    var title: String
    var tags: [String]
    var posterPic: String
    var director: String
    var isTV: Bool
    var dateReleased: String
    var status: String
    var language: String
    var duration: String
    var plot: String
    var keywords: [String]
    var seasons: String
    var audienceLevel: String
    var imbdRating: String
    var friendsRating: String
    var tomatoRating: String
    var platforms: [String]


}
