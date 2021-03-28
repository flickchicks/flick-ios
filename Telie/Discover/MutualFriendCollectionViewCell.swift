//
//  MutualFriendCollectionViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit
import Kingfisher

class MutualFriendCollectionViewCell: UICollectionViewCell {

    private let nameLabel = UILabel()
    private let mutualFriendsLabel = UILabel()
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()

    static let reuseIdentifier = "MutualFriendCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 32
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.movieWhite.cgColor
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        contentView.addSubview(profileImageView)

        nameLabel.textColor = .darkBlue
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(nameLabel)

        usernameLabel.textColor = .mediumGray
        usernameLabel.textAlignment = .center
        usernameLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(usernameLabel)

        mutualFriendsLabel.textColor = .mediumGray
        mutualFriendsLabel.textAlignment = .center
        mutualFriendsLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(mutualFriendsLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 64, height: 64))
            make.top.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(15)
        }

        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(15)
        }

        mutualFriendsLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(15)
        }
    }

    func configure(for friend: FriendRecommendation) {

        if let imageUrl = URL(string: friend.profilePicUrl ?? "") {
            profileImageView.kf.setImage(with: imageUrl)
        }
        nameLabel.text = friend.name
        usernameLabel.text = "@\(friend.username)"
        let numMutualFriends = friend.numMutualFriends
        mutualFriendsLabel.text = "\(numMutualFriends) mutual friend\(numMutualFriends > 1 ? "s" : "")"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

}
