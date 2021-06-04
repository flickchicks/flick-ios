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

    struct Notification {
        static let friendRequest = "notification_friend_request"
        static let likeComment = "notification_like_comment"
        static let listActivity = "notification_list_activity"
        static let suggestion = "notification_suggestion"
        static let collaborationInvite = "notification_collaboration_invite"
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

    static func logSelectContent(contentType: String, itemId: Int = -1) {
        Analytics.logEvent(
            AnalyticsEventSelectContent,
            parameters: [
                "content_type": contentType,
                "item_id": itemId
            ])
    }

}
