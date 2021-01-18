//
//  Date+Shared.swift
//  Flick
//
//  Created by Haiying W on 1/15/21.
//  Copyright © 2021 flick. All rights reserved.
//

import Foundation

extension Date {
    // ISO 8601 representation of date with fractional seconds
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
    
    /// Return the date label to be displayed given comment's created date
    func getDateLabelText(createdAt: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let createdAtDate = dateFormatter.date(from: createdAt)
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from:  createdAtDate!, to: currentDate)
        let componentsArray = [components.year, components.month, components.day, components.hour, components.minute, components.second]
        for componentIndex in 0..<componentsArray.count {
            if let c = componentsArray[componentIndex], c > 0 {
                if componentIndex == 0 {
                    return "\(c)y"
                } else if componentIndex == 1 {
                    return "\(c)m"
                } else if componentIndex == 2 {
                    return "\(c)d"
                } else if componentIndex == 3 {
                    return "\(c)h"
                } else if componentIndex == 4 {
                    return "\(c)m"
                } else {
                    return "\(c)s"
                }
            }
        }
        return "now" // Comment was just posted
    }
}

extension Formatter {
    // DateFormatter for ISO 8601 with fractional seconds
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}
