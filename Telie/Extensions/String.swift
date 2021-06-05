//
//  String.swift
//  Flick
//
//  Created by Lucy Xu on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import UIKit

extension String {

    init(_ likeActivityType: ActivityLike.ActivityLikeType) {
        switch likeActivityType {
            case .comment:
                self = "comment"
            case .suggestion:
                self = "suggestion"
        }
    }

    var inHourMinute: String {
        if let length = Int(self) {
            let hour = Int(floor(Double(length / 60)))
            let hourStr = hour > 0 ? "\(hour)h " : ""
            let minute = length % 60
            let minuteStr = minute > 0 ? "\(minute)m" : ""
            return "\(hourStr)\(minuteStr)"
        } else {
            return self
        }
    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }

}
