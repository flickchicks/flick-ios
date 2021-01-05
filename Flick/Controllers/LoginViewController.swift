//
//  LoginViewController.swift
//  Flick
//
//  Created by Lucy Xu on 5/22/20.
//  Copyright © 2020 flick. All rights reserved.
//

import AuthenticationServices
import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    private let userDefaults = UserDefaults.standard

    private let appleLoginButton = ASAuthorizationAppleIDButton()
    private let facebookLoginButton = UIButton()
    private let profileSize = CGSize(width: 400, height: 400)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true

        appleLoginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        view.addSubview(appleLoginButton)

        facebookLoginButton.setTitle("Continue with Facebook", for: .normal)
        facebookLoginButton.setTitleColor(.gradientPurple, for: .normal)
        facebookLoginButton.layer.backgroundColor = UIColor.lightPurple.cgColor
        facebookLoginButton.titleLabel?.font = .systemFont(ofSize: 17)
        facebookLoginButton.addTarget(self, action: #selector(initiateFacebookLogin), for: .touchUpInside)
        view.addSubview(facebookLoginButton)

        let loginButtonSize = CGSize(width: 240, height: 46)

        facebookLoginButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(loginButtonSize)
        }

        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(facebookLoginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(loginButtonSize)
        }

    }

    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
                            let user = User(username: profile.userID, firstName: firstName, lastName: lastName, profilePic: base64PictureString)
                            NetworkManager.registerUser(user: user) { [weak self] (registeredUser) in
                                guard let self = self else { return }
                                let encoder = JSONEncoder()
                                if let encodedRegisteredUser = try? encoder.encode(registeredUser) {
                                    // Upon successful registration of user, save user to user defaults
                                    self.userDefaults.set(encodedRegisteredUser, forKey: Constants.UserDefaults.authorizationToken)
                                }
                                let username = registeredUser.username
                                let socialIdToken = registeredUser.socialIdToken
                                self.loginUser(username: username, socialIdToken: socialIdToken!)
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

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("didCompleteWithAuthorization")
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            // Save a full name and email since you can't retrieve it later, e.g., save it in the key chain
            // Create an account in your system.
            // On success, remove the key
            // On fail, recover full name and email from the keychain and retry registration

            print(idTokenString)
            print(userIdentifier)
            print(fullName)
            print(email)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
        guard let error = error as? ASAuthorizationError else {
             return
         }

         switch error.code {
         case .canceled:
             print("Canceled")
         case .unknown:
             print("Unknown")
         case .invalidResponse:
             print("Invalid Respone")
         case .notHandled:
             print("Not handled")
         case .failed:
             print("Failed")
         @unknown default:
             print("Default")
         }
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
