//
//  SettingsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/20/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SettingsViewController: UIViewController {

    // MARK: - Private View Vars
    private let aboutButton = UIButton()
    private let editProfileButton = UIButton()
    private let headerView = UIView()
    private let logoutButton = UIButton()
    private let sendFeedbackButton = UIButton()
    private let settingsTitleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .offWhite
        setupNavigationBar()

        editProfileButton.setTitle("Edit Profile", for: .normal)
        editProfileButton.setTitleColor(.darkBlue, for: .normal)
        editProfileButton.titleLabel?.font = .systemFont(ofSize: 18)
        editProfileButton.contentHorizontalAlignment = .left
        view.addSubview(editProfileButton)

        sendFeedbackButton.setTitle("Send Feedback", for: .normal)
        sendFeedbackButton.setTitleColor(.darkBlue, for: .normal)
        sendFeedbackButton.titleLabel?.font = .systemFont(ofSize: 18)
        sendFeedbackButton.contentHorizontalAlignment = .left
        view.addSubview(sendFeedbackButton)

        aboutButton.setTitle("About", for: .normal)
        aboutButton.setTitleColor(.darkBlue, for: .normal)
        aboutButton.titleLabel?.font = .systemFont(ofSize: 18)
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

    @objc func logout() {
        LoginManager().logOut()
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }

    private func setupConstraints() {
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }

        sendFeedbackButton.snp.makeConstraints { make in
            make.top.equalTo(editProfileButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }

        aboutButton.snp.makeConstraints { make in
            make.top.equalTo(sendFeedbackButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }

        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(aboutButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        settingsTitleLabel.text = "Settings"
        settingsTitleLabel.font = .systemFont(ofSize: 18)
        settingsTitleLabel.textColor = .black
        navigationController?.navigationBar.addSubview(settingsTitleLabel)

        settingsTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(59)
            make.top.bottom.trailing.equalToSuperview()
        }

        headerView.backgroundColor = .movieWhite
        headerView.clipsToBounds = false
        headerView.layer.masksToBounds = false
        // TODO: Double check tab bar shadows
        headerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        headerView.layer.shadowOpacity = 0.07
        headerView.layer.shadowOffset = .init(width: 0, height: 4)
        headerView.layer.shadowRadius = 8
        view.addSubview(headerView)

        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(10)
        }

    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsTitleLabel.removeFromSuperview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
