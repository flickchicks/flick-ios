//
//  Body.swift
//  Flick
//
//  Created by Lucy Xu on 5/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

// MARK: - Request Bodies

struct MediaListBody: Codable {

    var movieIds: [String]
    var collaborators: [String]
    var isPrivate: Bool
    var timestamp: String
    var listName: String
    var tags: [String]
    var listPic: String

}
