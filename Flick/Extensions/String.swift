//
//  String.swift
//  Flick
//
//  Created by Lucy Xu on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

extension String {
    init(_ likeActivityType: ActivityLike.ActivityLikeType) {
        switch likeActivityType {
            case .comment:
                self = "comment"
            case .suggestion:
                self = "suggestion"
        }

    }
}
