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
    static let darkBlue2 = colorFromCode(0x3F3A58)
    static let darkPurple = colorFromCode(0x2B25A6)
    static let deepPurple = colorFromCode(0x2B254A)
    static let lightPurple = colorFromCode(0xF7F5FE)
    static let lightPurple = colorFromCode(0xE8E2FF)
    static let mediumGray = colorFromCode(0x6E6E87)
    static let offWhite = colorFromCode(0xF7F5FE)

    public static func colorFromCode(_ code: Int) -> UIColor {
        let red = CGFloat(((code & 0xFF0000) >> 16)) / 255
        let green = CGFloat(((code & 0xFF00) >> 8)) / 255
        let blue = CGFloat((code & 0xFF)) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

}
