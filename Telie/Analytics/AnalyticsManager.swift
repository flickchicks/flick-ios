//
//  AnalyticsManager.swift
//  Telie
//
//  Created by Lucy Xu on 5/28/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import Foundation
import Firebase

class AnalyticsManager {

    static let shared: AnalyticsManager = AnalyticsManager()

    static func logEventLogin(name: String) {
        Analytics.logEvent(
            "AnalyticsEventLogin",
            parameters: [
                "name": name
            ]
        )
    }

    static func logEventAppOpen() {
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
    }

    static func logFirebaseShareEvent() {
        Analytics.logEvent(AnalyticsEventShare, parameters: nil)
    }

}
