//
//  CustomBannerColors.swift
//  Telie
//
//  Created by Lucy Xu on 4/3/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class CustomBannerColors: BannerColorsProtocol {

    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
            case .info:
                return UIColor.lightPurple
            default:
                return UIColor.green
        }
    }

}
