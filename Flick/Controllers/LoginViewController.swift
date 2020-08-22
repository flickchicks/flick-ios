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
    private let loginButton = UIButton()
    private let profileSize = CGSize(width: 400, height: 400)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true

        loginButton.setTitle("Continue with Facebook", for: .normal)
        loginButton.setTitleColor(.gradientPurple, for: .normal)
        loginButton.layer.backgroundColor = UIColor.lightPurple.cgColor
        loginButton.titleLabel?.font = .systemFont(ofSize: 17)
        loginButton.addTarget(self, action: #selector(initiateFacebookLogin), for: .touchUpInside)
        view.addSubview(loginButton)

        let loginButtonSize = CGSize(width: 240, height: 46)

        loginButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(loginButtonSize)
        }

    }

    @objc func initiateFacebookLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [], from: self) { [weak self] (result, error) in
            guard let self = self else { return }

            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            guard let result = result, !result.isCancelled else {
                return
            }

            Profile.loadCurrentProfile { (profile, error) in
                if  let profile = profile,
                    let accessToken = AccessToken.current?.tokenString,
                    let firstName = profile.firstName,
                    let lastName = profile.lastName,
                    let profileURL = profile.imageURL(forMode: .normal, size: self.profileSize) {
                        let pictureData = try? Data(contentsOf: profileURL)
                        if let pictureData = pictureData {
                            let pictureObject = UIImage(data: pictureData)
                            let base64PictureString = pictureObject!.pngData()?.base64EncodedString()
                            let user = User(username: profile.userID, firstName: firstName, lastName: lastName, profilePic: base64PictureString!, socialIdToken: accessToken, socialIdTokenType: "facebook")
                            NetworkManager.registerUser(user: user) { [weak self] (registeredUser) in
                                guard let self = self else { return }
                                let encoder = JSONEncoder()
                                if let encodedRegisteredUser = try? encoder.encode(registeredUser) {
                                    // Upon successful registration of user, save user to user defaults
                                    self.userDefaults.set(encodedRegisteredUser, forKey: Constants.UserDefaults.authorizationToken)
                                }
                                let username = registeredUser.username
                                let socialIdToken = registeredUser.socialIdToken
                                self.loginUser(username: username, socialIdToken: socialIdToken)
                            }
                        }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}

extension LoginViewController {

    private func loginUser(username: String, socialIdToken: String) {
        NetworkManager.loginUser(username: username, socialIdToken: socialIdToken) { [weak self] (authorizationToken) in
            guard let self = self else { return }
            self.userDefaults.set(authorizationToken, forKey: Constants.UserDefaults.authorizationToken)
            let homeViewController = HomeViewController()
            self.navigationController?.pushViewController(homeViewController, animated: true)
        }
    }

}
