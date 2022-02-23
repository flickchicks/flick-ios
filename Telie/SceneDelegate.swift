//
//  SceneDelegate.swift
//  Flick
//
//  Created by Lucy Xu on 5/22/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Siren
import UIKit
import FBSDKLoginKit
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 0
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MediaCommentsViewController.self)

        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = LaunchViewController()
        window.makeKeyAndVisible()
        Siren.shared.wail()

        // Check authorizationToken is in userDefaults
        guard let _ = UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizationToken) else {
//            window.rootViewController = CustomNavigationController(rootViewController: LoginViewController())
            window.rootViewController = CustomNavigationController(rootViewController: CreateReactionViewController())
            return
        }
        // We have correct authorization token
        NetworkManager.getUserProfile { profile in
            DispatchQueue.main.async {
                guard let profile = profile else {
//                    window.rootViewController = CustomNavigationController(rootViewController: LoginViewController())
                    window.rootViewController = CustomNavigationController(rootViewController: CreateReactionViewController())
                    return
                }
                UserDefaults.standard.set(profile.id, forKey: Constants.UserDefaults.userId)

                // Register user for notifications
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    print("Notification settings: \(settings)")
                    if settings.authorizationStatus == .authorized {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }

                let tabBarController = TabBarController()
                // If connected from notification tap, show notification tab
                if connectionOptions.notificationResponse != nil {
                    tabBarController.selectedIndex = 1
                }
                window.rootViewController = CustomNavigationController(rootViewController: tabBarController)
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        // Reference: https://fluffy.es/how-to-transition-from-login-screen-to-tab-bar-controller/
        guard let window = self.window else {
            return
        }

        // Change the root view controller to your specific view controller
        window.rootViewController = vc

        if animated {
            UIView.transition(with: window,
                              duration: 0.5,
                              options: [.transitionFlipFromLeft],
                              animations: nil,
                              completion: nil)
        }
    }

}

