//
//  AnalyticsManager.swift
//  Telie
//
//  Created by Lucy Xu on 5/28/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import Foundation
import Firebase

struct SelectContentType {

    struct Discover {
        static let friendSuggestion = "discover_friend_suggestion"
        static let listSuggestion = "discover_list_suggestion"
        static let showSuggestion = "discover_show_suggestion"
        static let commentActivity = "discover_comment_activity"
    }

}

class AnalyticsManager {

    static let shared: AnalyticsManager = AnalyticsManager()

    static func logEventLogin(method: String) {
        Analytics.logEvent(
            AnalyticsEventLogin,
            parameters: [
                "method": method
            ]
        )
    }

    static func logShareEvent(method: String) {
        Analytics.logEvent(
            AnalyticsEventShare,
            parameters: [
                "method": method
            ])
    }

    static func logSelectContent(contentType: String, itemId: Int) {
        Analytics.logEvent(
            AnalyticsEventSelectContent,
            parameters: [
                "content_type": contentType,
                "item_id": itemId
            ])
    }

}
