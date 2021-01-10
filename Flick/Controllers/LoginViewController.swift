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
    private let profileSize = CGSize(width: 50, height: 50)

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
                    var base64Str = ""
                    let profileURLData = try? Data(contentsOf: profileURL)
                    if let profileURLData = profileURLData,
                       let profileImage = UIImage(data: profileURLData),
                       let profileImagePngData = profileImage.pngData() {
                        base64Str = profileImagePngData.base64EncodedString()
                    }
                    
                    NetworkManager.authenticateUser(
                        username: "",
                        firstName: firstName,
                        lastName: lastName,
                        profilePic: base64Str,
                        socialId: profile.userID,
                        socialIdToken: accessToken) { [weak self] authorizationToken in
                        guard let self = self else { return }
                        DispatchQueue.main.async {
                            self.userDefaults.set(authorizationToken, forKey: Constants.UserDefaults.authorizationToken)
                            let homeViewController = HomeViewController()
                            self.navigationController?.pushViewController(homeViewController, animated: true)
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
