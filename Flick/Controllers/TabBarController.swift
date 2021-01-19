//
//  TabBarController.swift
//  Flick
//
//  Created by Haiying W on 1/17/21.
//  Copyright © 2021 flick. All rights reserved.
//

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

        let discoverVC = DiscoverViewController()
        let searchIconImage = UIImage(named: "searchIcon")
        let selectedSearchIconImage = UIImage(named: "selectedSearchIcon")
        discoverVC.tabBarItem = UITabBarItem(title: "Discover", image: searchIconImage, selectedImage: selectedSearchIconImage)

        let profileVC = ProfileViewController(isHome: true, userId: nil)
        let profileIconImage = UIImage(named: "profileIcon")
        let selectedProfileIconImage = UIImage(named: "selectedProfileIcon")
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: profileIconImage, selectedImage: selectedProfileIconImage)

        let notificationVC = AllNotificationsViewController()
        let notificationIconImage = UIImage(named: "notificationIcon")
        let selectedNotificationIconImage = UIImage(named: "selectedNotificationIcon")
        notificationVC.tabBarItem = UITabBarItem(title: "Notifications", image: notificationIconImage, selectedImage: selectedNotificationIconImage)

        let tabBarList = [discoverVC, profileVC, notificationVC]

        viewControllers = tabBarList
    }

}
