//
//  TabBarController.swift
//  Flick
//
//  Created by Haiying W on 1/17/21.
//  Copyright © 2021 flick. All rights reserved.
//

import SPPermissions
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = tabBar.standardAppearance
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundColor = .white
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkBlueGray2]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gradientPurple]
        tabBar.standardAppearance = appearance;
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        tabBar.layer.shadowColor = UIColor.darkBlueGray2.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowRadius = 4
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)

        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkBlueGray2]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gradientPurple]
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }

        let discoverVC = DiscoverViewController()
        let searchIconImage = UIImage(named: "searchIcon")
        let selectedSearchIconImage = UIImage(named: "selectedSearchIcon")
        discoverVC.tabBarItem = UITabBarItem(title: "Discover", image: searchIconImage, selectedImage: selectedSearchIconImage)

//        let groupsVC = GroupsViewController()
//        let groupsIconImage = UIImage(named: "groupsIcon")
//        let selectedGroupsIconImage = UIImage(named: "selectedGroupsIcon")
//        groupsVC.tabBarItem = UITabBarItem(title: "Groups", image: groupsIconImage, selectedImage: selectedGroupsIconImage)

//        let notificationVC = AllNotificationsViewController()
//        let notificationIconImage = UIImage(named: "notificationIcon")
//        let selectedNotificationIconImage = UIImage(named: "selectedNotificationIcon")
//        notificationVC.tabBarItem = UITabBarItem(title: "Notifications", image: notificationIconImage, selectedImage: selectedNotificationIconImage)

        let profileVC = ProfileViewController(isHome: true, userId: nil)
        let profileIconImage = UIImage(named: "profileIcon")
        let selectedProfileIconImage = UIImage(named: "selectedProfileIcon")
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: profileIconImage, selectedImage: selectedProfileIconImage)

        let tabBarList = [discoverVC, profileVC]

        viewControllers = tabBarList
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UserDefaults.standard.bool(forKey: Constants.UserDefaults.didPromptPermission) {
            showPermissionModal()
        }
    }

}

extension TabBarController: SPPermissionsDataSource, SPPermissionsDelegate {

    func showPermissionModal() {
        let controller = SPPermissions.dialog([.notification])
        // Ovveride texts in controller
        controller.titleText = "Permission Request"
        controller.headerText = ""
        controller.dataSource = self
        controller.delegate = self
        controller.present(on: self)
    }

    func configure(_ cell: SPPermissionTableViewCell, for permission: SPPermission) -> SPPermissionTableViewCell {
        // Titles
        cell.permissionTitleLabel.text = "Notifications"
        cell.button.allowTitle = "Allow"
        cell.button.allowedTitle = "Allowed"

        // Colors
        cell.iconView.color = .gradientPurple
        cell.button.allowBackgroundColor = .gradientPurple
        cell.button.allowedBackgroundColor = .gradientPurple
        cell.button.allowTitleColor = .white
        cell.button.allowedTitleColor = .white

        return cell
    }

    func didAllow(permission: SPPermission) {
        UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.didPromptPermission)
        UIApplication.shared.registerForRemoteNotifications()
    }

    func didDenied(permission: SPPermission) {
        UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.didPromptPermission)
    }

    func didHide(permissions ids: [Int]) {
        UserDefaults.standard.setValue(true, forKey: Constants.UserDefaults.didPromptPermission)
    }

    func deniedData(for permission: SPPermission) -> SPPermissionDeniedAlertData? {
        if permission == .notification {
            let data = SPPermissionDeniedAlertData()
            data.alertOpenSettingsDeniedPermissionTitle = "Permission denied"
            data.alertOpenSettingsDeniedPermissionDescription = "If you would like to receive push notifications, please go to Settings"
            data.alertOpenSettingsDeniedPermissionButtonTitle = "Settings"
            data.alertOpenSettingsDeniedPermissionCancelTitle = "Cancel"
            return data
        } else {
            // If returned nil, alert will not show.
            return nil
        }
    }

}
