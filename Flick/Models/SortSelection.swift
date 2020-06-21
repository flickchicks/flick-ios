//
//  SortSelection.swift
//  Flick
//
//  Created by Lucy Xu on 6/20/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

enum SortDirection { case ascending, descending, unselected }

class SortSelection {

    var description: String
    var sortDirection: SortDirection

    init(description: String, sortDirection: SortDirection) {
        self.description = description
        self.sortDirection = sortDirection
    }

}
