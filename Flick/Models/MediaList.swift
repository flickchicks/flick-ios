//
//  MediaList.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct MediaList: Codable {

    var movieIds: [String]
    var collaborators: [String]
    var isPrivate: Bool
    var isFavorite: Bool
    var timestamp: String
    var name: String
    var picture: String
    var tags: [String]

}
