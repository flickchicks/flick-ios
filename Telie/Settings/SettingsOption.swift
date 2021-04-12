//
//  SettingsOption.swift
//  Telie
//
//  Created by Lucy Xu on 4/12/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

enum SettingsOption: String {
    case editProfile = "Edit Profile"
    case buyCoffee = "Buy Us a Coffee"
    case sendFeedback = "Send Feedback"
    case about = "About"
    case logout = "Log Out"
    case deleteAccount = "Delete Account"

    var image: UIImage? {
        var imageName: String {
            switch self {
            case .editProfile:
                return "settingsPencilIcon"
            case .buyCoffee:
                return "buyMeCoffee"
            case .sendFeedback:
                return "messageIcon"
            case .about:
                return "settingsInfoIcon"
            case .logout:
                return "logOutIcon"
            case .deleteAccount:
                return "settingsTrashIcon"
            }
        }
        return UIImage(named: imageName)
    }

    var color: UIColor {
        switch self {
        case .logout, .deleteAccount:
            return .flickRed
        default:
            return .darkBlue
        }
    }

}
