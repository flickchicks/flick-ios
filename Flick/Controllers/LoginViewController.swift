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
                                let pictureObject = UIImage(data: pictureData)
                                let base64PictureString = pictureObject!.pngData()?.base64EncodedString()
                                let user = User(username: userId, firstName: firstName, lastName: lastName, profilePic: base64PictureString!, socialIdToken: accessToken, socialIdTokenType: "facebook")
                                NetworkManager.registerUser(user: user) { (registeredUser) in
                                    let encoder = JSONEncoder()
                                    if let encodedRegisteredUser = try? encoder.encode(registeredUser) {
                                        self.userDefaults.set(encodedRegisteredUser, forKey: "user")
                                    }
                                }
                            }
                       }
                }
            })
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out.")
    }


}
