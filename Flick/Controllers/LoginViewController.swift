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
        print("here")
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                 parameters: ["fields": "email, first_name, last_name, picture"],
                                                 tokenString: token,
                                                 version: nil,
                                                 httpMethod: .get)
        request.start(completionHandler: { connection, result, error in
            if let result = result {
                guard let user = result as? [String: Any] else { return }
                if let firstName = user["first_name"] as? String,
                    let lastName = user["last_name"] as? String,
                    let userId = user["id"] as? String,
                    let pictureObject = user["picture"] as? [String: Any],
                    let pictureData = pictureObject["data"] as? [String: Any],
                    let pictureUrlString = pictureData["url"] as? String
                   {
                        let url = URL(string: pictureUrlString)
                        let data = try? Data(contentsOf: url!)
                        if let imageData = data {
                            let imageObject = UIImage(data: imageData)
                            let strBase64 = imageObject!.pngData()?.base64EncodedString()
                            self.userDefaults.set(firstName, forKey: "firstName")
                            self.userDefaults.set(lastName, forKey: "lastName")
                            self.userDefaults.set(userId, forKey: "userId")
                            let user = User(username: userId, firstName: firstName, lastName: lastName, profilePic: strBase64!)
                            NetworkManager.createUser(user: user, accessToken: token!)
                        }
                   }
            }
        })
    }

    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out.")
    }


}
