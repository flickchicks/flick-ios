//
//  Group.swift
//  Flick
//
//  Created by Haiying W on 1/29/21.
//  Copyright © 2021 flick. All rights reserved.
//

import Foundation

struct Group: Codable {
    var id: Int
    var name: String
    var members: [UserProfile]?
    var shows: [Media]?
}

struct PendingIdeas: Codable {
    var requestTimestamp: String
    var shows: [Media]
}

struct GroupResult: Codable {
    var numMembers: Int
    var numVoted: Int
    var userVoted: Bool
    var results: [MediaResult]
}

struct MediaResult: Codable {
    var id: Int
    var numYesVotes: Int
    var numMaybeVotes: Int
    var numNoVotes: Int
    var title: String
    var posterPic: String?
    var backdropPic: String?
    var isTv: Bool
    var plot: String?
    var dateReleased: String?
    var language: String?
}

enum Vote: String {
    case maybe, no, yes
}
