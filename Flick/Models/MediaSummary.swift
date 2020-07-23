//
//  MediaSummary.swift
//  Flick
//
//  Created by Lucy Xu on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

enum SummaryType {
    case duration, year, releaseStatus, rating, language, director, spacer
}

struct MediaSummary {
    let text: String
    let type: SummaryType

    init(text: String, type: SummaryType) {
       self.text = text
       self.type = type
    }

    init(type: SummaryType) {
        self.text = ""
       self.type = type
    }
}
