//
//  LoginViewController.swift
//  Flick
//
//  Created by Lucy Xu on 5/22/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    private let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        loginButton.center = view.center
        view.addSubview(loginButton)
    }

}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let accessToken = result?.token?.tokenString {
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                     parameters: ["fields": "email, first_name, last_name, picture"],
                                                     tokenString: accessToken,
                                                     version: nil,
                                                     httpMethod: .get)
            request.start(completionHandler: { connection, result, error in
                if let result = result {
                    guard let user = result as? [String: Any] else { return }
                    if let firstName = user["first_name"] as? String,
                        let lastName = user["last_name"] as? String,
                        let userId = user["id"] as? String,
                        let pictureObject = user["picture"] as? [String: Any],
                        let pictureContent = pictureObject["data"] as? [String: Any],
                        let pictureUrlString = pictureContent["url"] as? String
                       {
                            let pictureUrl = URL(string: pictureUrlString)
                            let pictureData = try? Data(contentsOf: pictureUrl!)
                            if let pictureData = pictureData {
                                // Convert image to base64 string
                                let pictureObject = UIImage(data: pictureData)
                                let base64PictureString = pictureObject!.pngData()?.base64EncodedString()
                                let user = User(username: userId, firstName: firstName, lastName: lastName, profilePic: base64PictureString!, socialIdToken: accessToken, socialIdTokenType: "facebook")
                                NetworkManager.registerUser(user: user) { [weak self] (registeredUser) in
                                    guard let self = self else { return }
                                    let encoder = JSONEncoder()
                                    let decoder = JSONDecoder()
                                    if let encodedRegisteredUser = try? encoder.encode(registeredUser) {
                                        // Upon successful registration of user, save user to user defaults
                                        self.userDefaults.set(encodedRegisteredUser, forKey: Constants.UserDefaults.authorizationToken)
                                    }
                                    if let storedUser = self.userDefaults.data(forKey: Constants.UserDefaults.authorizationToken) {
                                        if let decodedUser = try? decoder.decode(User.self, from: storedUser) {
                                            let username = decodedUser.username
                                            let socialIdToken = decodedUser.socialIdToken
                                            // Upon successful registration, log user into application and save authorization token and username
                                            self.loginUser(username: username, socialIdToken: socialIdToken)
                                        }
                                    }
                                }
                            }
                       }
                }
            })
        }
    }

    private func loginUser(username: String, socialIdToken: String) {
        NetworkManager.loginUser(username: username, socialIdToken: socialIdToken) { [weak self] (authorizationToken) in
            guard let self = self else { return }
            self.userDefaults.set(authorizationToken, forKey: Constants.UserDefaults.authorizationToken)
            let homeViewController = HomeViewController()
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out.")
    }


}
