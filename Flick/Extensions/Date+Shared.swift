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
