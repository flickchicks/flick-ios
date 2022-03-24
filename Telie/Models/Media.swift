//
//  Media.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct SimpleMedia: Codable {
    var id: Int
    var title: String
    var posterPic: String?
    var isTv: Bool?
    var directors: String?
    var plot: String?
    var tags: [Tag]?
    var dateReleased: String?
    var savedToLsts: [SavedToLst]?
}

struct SavedToLst: Codable {
    let lstId: Int
    let lstName: String
    let savedBy: UserProfile
}

struct Media: Codable {
    var id: Int
    var title: String
    var posterPic: String?
    var directors: String?
    var isTv: Bool
    var dateReleased: String?
    var providers: [Provider]?
    var status: String?
    var language: String?
    var duration: String?
    var plot: String?
    var tags: [Tag]?
    var seasons: Int?
    var audienceLevel: String?
    var imdbRating: Int?
    var tomatoRating: Int?
    var friendsRating: Int?
    var userRating: Int?
    var comments: [Comment]?
    var platforms: [String]?
    var keywords: [String]?
    var cast: String?
    var seasonDetails: [SeasonDetail]?
}

struct SeasonDetail: Codable {
    var id: Int
    var seasonNum: Int
    var episodeDetails: [EpisodeDetail]?
}

struct EpisodeDetail: Codable {
    var id: Int
    var episodeNum: Int
    var name: String?
    var reactions: [Reaction]?
}
