//
//  LoginViewController.swift
//  Flick
//
//  Created by Lucy Xu on 5/22/20.
//  Copyright © 2020 flick. All rights reserved.
//

import AuthenticationServices
import FBSDKLoginKit
import UIKit

class LoginViewController: UIViewController {

    private let userDefaults = UserDefaults.standard

    private let appleLoginButton = LoginButton(type: .apple, backgroundColor: .black)
    private let facebookLoginButton = LoginButton(type: .facebook, backgroundColor: .facebookBlue)
    private let profileSize = CGSize(width: 50, height: 50)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightPurple
        navigationController?.navigationBar.isHidden = true

        appleLoginButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        view.addSubview(appleLoginButton)

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
            guard let self = self else { return }

            guard error == nil else {
                print(error!.localizedDescription)
                return
            }

            guard let result = result, !result.isCancelled else {
                return
            }

            // Get user email from graph request
            GraphRequest(graphPath: "me", parameters: ["fields": "email"], tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get).start { (connection, result, error) -> Void in
                var email: String?
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    if let result = result,
                       let user = result as? [String: Any],
                       let userEmail = user["email"] as? String {
                        email = userEmail
                    }
                }
                self.loadFBProfile(email: email)
            }
        }
    }

    private func loadFBProfile(email: String?) {
        Profile.loadCurrentProfile { (profile, error) in
            if let accessToken = AccessToken.current?.tokenString,
               let profile = profile,
               let firstName = profile.firstName,
               let lastName = profile.lastName {
                // Get profile image in base64
                var base64Str = ""
                if let profileURL = profile.imageURL(forMode: .normal, size: self.profileSize) {
                    let profileURLData = try? Data(contentsOf: profileURL)
                    if let profileURLData = profileURLData,
                       let profileImage = UIImage(data: profileURLData),
                       let profileImagePngData = profileImage.pngData() {
                        base64Str = profileImagePngData.base64EncodedString()
                    }
                }

                self.authenticateUser(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    profilePic: base64Str,
                    socialId: profile.userID,
                    socialIdToken: accessToken,
                    socialIdTokenType: "facebook"
                )
            }
        }
    }

    private func authenticateUser(firstName: String,
                                  lastName: String,
                                  email: String?,
                                  profilePic: String,
                                  socialId: String,
                                  socialIdToken: String,
                                  socialIdTokenType: String) {
        NetworkManager.authenticateUser(
            firstName: firstName,
            lastName: lastName,
            email: email,
            profilePic: profilePic,
            socialId: socialId,
            socialIdToken: socialIdToken,
            socialIdTokenType: socialIdTokenType) { [weak self] authorizationToken in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.userDefaults.set(authorizationToken, forKey: Constants.UserDefaults.authorizationToken)
                let homeViewController = HomeViewController()
                self.navigationController?.pushViewController(homeViewController, animated: true)
            }
        }
    }

}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            guard let appleIDToken = appleIDCredential.identityToken else {
//                print("Unable to fetch identity token")
//                return
//            }
//
//            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                return
//            }

            guard let authorizationCode = appleIDCredential.authorizationCode,
                  let authCode = String(data: authorizationCode, encoding: .utf8) else {
                print("Problem with the authorizationCode")
                return
            }

            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

//            print(idTokenString)
            print(userIdentifier)
            print(fullName)
            print(email)
            print(authCode)

            authenticateUser(
                firstName: fullName?.givenName ?? "",
                lastName: fullName?.familyName ?? "",
                email: email,
                profilePic: "",
                socialId: userIdentifier,
                socialIdToken: "some token \(userIdentifier)",
                socialIdTokenType: "apple"
            )
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
