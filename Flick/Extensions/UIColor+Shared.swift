//
//  UIColor+Shared.swift
//  Flick
//
//  Created by Lucy Xu on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

extension UIColor {

    static let darkBlue = colorFromCode(0x0B0629)
    static let darkBlueGray2 = colorFromCode(0x3F3A58)
    static let darkPurple = colorFromCode(0x2B25A6)
    static let deepPurple = colorFromCode(0x2B254A)
    // TODO: Update name and add gradient
    static let gradientPurple = colorFromCode(0x5A1C97)
    static let lightPurple = colorFromCode(0xE8E2FF)
    static let mediumGray = colorFromCode(0x6E6E87)
    static let lightGray = colorFromCode(0xBABACA)
    static let lightGray2 = colorFromCode(0xE9EAF1)
    // TODO: Update lightGray3 name
    static let lightGray3 = colorFromCode(0xF0F1F8)
    static let lightGray4 = colorFromCode(0xD5D5DF)
    static let offWhite = colorFromCode(0xF7F5FE)
    // TODO: Update movieWhite name
    static let movieWhite = colorFromCode(0xFBFBFF)
    static let purpleOverlay = UIColor(red: 0.054, green: 0.041, blue: 0.308, alpha: 0.3)
    static let flickRed = colorFromCode(0xDA0F33)

    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

}
