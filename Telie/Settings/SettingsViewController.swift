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
    private let settingsTableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Private Data Vars
    private let settingsOptions: [SettingsOption] = [
        .editProfile,
        .buyCoffee,
        .sendFeedback,
        .about,
        .logout,
        .deleteAccount
    ]
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

        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.backgroundColor = .clear
        settingsTableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        settingsTableView.contentInset = UIEdgeInsets(top: 20, left: 12, bottom: 20, right: 12)
        settingsTableView.separatorStyle = .none
        settingsTableView.isScrollEnabled = false
        view.addSubview(settingsTableView)

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

    func showEditProfile() {
        let editProfileViewController = EditProfileViewController(user: user)
        editProfileViewController.delegate = self
        navigationController?.pushViewController(editProfileViewController, animated: true)
    }

    private func setupConstraints() {
        settingsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    func showAboutVC() {
        navigationController?.pushViewController(AboutViewController(), animated: true)
    }
    
    func sendFeedback() {
        if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfU2Wn5uVFEuaWLmcBFZCm_UQiNRHKGKChgV8rgpLWFMtjp0Q/viewform") {
            UIApplication.shared.open(url)
        }
    }

    func buyMeACoffee() {
        if let url = URL(string: "https://www.buymeacoffee.com/telie") {
            UIApplication.shared.open(url)
        }
    }

    func presentDeleteAccountAlert() {
        let deleteAction = UIAlertAction(title: "Delete Account", style: .destructive) { [weak self] action in
            guard let self = self else { return }
            self.deleteUserAccount()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let deleteAlert = UIAlertController(title: "Are you sure you want to delete your account?",
             message: "All of your data will be deleted. This cannot be undone.",
             preferredStyle: .actionSheet)
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(deleteAction)

        self.present(deleteAlert, animated: true)
    }

    func deleteUserAccount() {
        NetworkManager.deleteUser { [weak self] success in
            guard let self = self else { return }
            if success {
                self.logout()
            }
        }
    }

}

extension SettingsViewController: EditProfileDelegate {

    func updateUser(user: UserProfile) {
        self.user = user
    }

}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: settingsOptions[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingOption = settingsOptions[indexPath.row]
        switch settingOption {
        case .editProfile:
            showEditProfile()
        case .buyCoffee:
            buyMeACoffee()
        case .sendFeedback:
            sendFeedback()
        case .about:
            showAboutVC()
        case .logout:
            logout()
        case .deleteAccount:
            presentDeleteAccountAlert()
        }
    }
}
