//
//  Comment.swift
//  Flick
//
//  Created by Lucy Xu on 7/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

struct Comment {
    var name: String
    var comment: String
    var date: String

    init(name: String, comment: String, date: String) {
       self.name = name
       self.comment = comment
        self.date = date
    }
}
