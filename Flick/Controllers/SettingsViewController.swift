//
//  SettingsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/20/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Kingfisher

class SettingsViewController: UIViewController {

    // MARK: - Private View Vars
    private let aboutButton = UIButton()
    private let editProfileButton = UIButton()
    private let logoutButton = UIButton()
    private let sendFeedbackButton = UIButton()

    // MARK: - Private Data Vars
    private var user: UserProfile

    init(user: UserProfile) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        view.backgroundColor = .offWhite

        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.setTitleColor(.black, for: .normal)
        editProfileButton.titleLabel?.font = .systemFont(ofSize: 18)
        editProfileButton.addTarget(self, action: #selector(showEditProfile), for: .touchUpInside)
        editProfileButton.contentHorizontalAlignment = .left
        view.addSubview(editProfileButton)

        sendFeedbackButton.setTitle("Send Feedback", for: .normal)
        sendFeedbackButton.setTitleColor(.black, for: .normal)
        sendFeedbackButton.titleLabel?.font = .systemFont(ofSize: 18)
        sendFeedbackButton.contentHorizontalAlignment = .left
        sendFeedbackButton.addTarget(self, action: #selector(sendFeedbackPressed), for: .touchUpInside)
        view.addSubview(sendFeedbackButton)

        aboutButton.setTitle("About", for: .normal)
        aboutButton.setTitleColor(.black, for: .normal)
        aboutButton.titleLabel?.font = .systemFont(ofSize: 18)
        aboutButton.addTarget(self, action: #selector(showAboutVC), for: .touchUpInside)
        aboutButton.contentHorizontalAlignment = .left
        view.addSubview(aboutButton)

        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.flickRed, for: .normal)
        logoutButton.titleLabel?.font = .systemFont(ofSize: 18)
        logoutButton.contentHorizontalAlignment = .left
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        view.addSubview(logoutButton)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    @objc func logout() {
        if user.socialIdTokenType == "facebook" {
            LoginManager().logOut()
        }
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.authorizationToken)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.didPromptPermission)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.userId)
        URLCache.shared.removeAllCachedResponses()
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(LoginViewController())
    }

    @objc func showEditProfile() {
        let editProfileViewController = EditProfileViewController(user: user)
        editProfileViewController.delegate = self
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }

    private func setupConstraints() {
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }

        sendFeedbackButton.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }

        aboutButton.snp.makeConstraints { make in
            make.top.equalTo(sendFeedbackButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }

        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(aboutButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.07
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationController?.navigationBar.layer.shadowRadius = 8
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showAboutVC() {
        navigationController?.pushViewController(AboutViewController(), animated: true)
    }
    
    @objc func sendFeedbackPressed() {
        if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfU2Wn5uVFEuaWLmcBFZCm_UQiNRHKGKChgV8rgpLWFMtjp0Q/viewform") {
            UIApplication.shared.open(url)
        }
    }

}

extension SettingsViewController: EditProfileDelegate {
    func updateUser(user: UserProfile) {
        self.user = user
    }
}
