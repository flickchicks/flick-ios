//
//  ProfileViewController.swift
//  Flick
//
//  Created by Lucy Xu on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Private View Vars
    private let profileImageView = UIImageView()
    private let noticationButton = UIButton()
    private let etcButton = UIButton()
    private let nameLabel = UILabel()
    private let usernameLabel = UILabel()
    // private let friendsCollectionView = UICollectionView()
//    private let summaryCollectionView = UICollectionView()
    private let roundTopView = RoundTopView(hasShadow: true)
    private let listsTableView = UITableView()

    private let profileImageSize = CGSize(width: 70, height: 70)

    // TODO: Update with backend values
    private let name = "Alanna Zhou"
    private let username = "alannaz"

    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = .lightPurple

        profileImageView.backgroundColor = .darkPurple
        profileImageView.layer.cornerRadius = profileImageSize.width / 2
        view.addSubview(profileImageView)

        nameLabel.text = name
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = .darkBlue
        view.addSubview(nameLabel)

        usernameLabel.text = "@\(username)"
        usernameLabel.font = .systemFont(ofSize: 12)
        usernameLabel.textColor = .mediumGray
        view.addSubview(usernameLabel)

        setupConstraints()
    }

    private func setupConstraints() {

        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(23)
            make.size.equalTo(profileImageSize)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.centerX.equalTo(view.snp.leading)
            make.height.equalTo(24)
        }


    }

}
