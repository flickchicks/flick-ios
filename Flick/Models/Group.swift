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
    var members: [UserProfile]
    var shows: [Media]?
}
