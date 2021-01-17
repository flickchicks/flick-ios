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

        tabBar.clipsToBounds = true
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white

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

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkBlueGray2], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gradientPurple], for: .selected)

        let tabBarList = [discoverVC, profileVC, notificationVC]

        viewControllers = tabBarList
    }

}
