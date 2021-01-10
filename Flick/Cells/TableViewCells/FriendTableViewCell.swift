//
//  FriendTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 1/2/21.
//  Copyright © 2021 flick. All rights reserved.
//

import Kingfisher
import UIKit

class FriendTableViewCell: UITableViewCell {
    
    // MARK: - Private View Vars
    private let nameLabel = UILabel()
    private let userProfileImageView = UIImageView()
    private let usernameLabel = UILabel()

    // MARK: - Data Vars
    static let reuseIdentifier = "FriendsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear

        userProfileImageView.clipsToBounds = true
        userProfileImageView.layer.cornerRadius = 20
        userProfileImageView.layer.backgroundColor = UIColor.darkPurple.cgColor
        contentView.addSubview(userProfileImageView)
        
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .darkBlue
        contentView.addSubview(nameLabel)
        
        usernameLabel.font = .systemFont(ofSize: 10)
        usernameLabel.textColor = .mediumGray
        contentView.addSubview(usernameLabel)
        
        setupConstraints()
    }
    
    func configure(user: UserProfile) {
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.username)"
        if let profilePic = user.profilePic {
            userProfileImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePic, cacheKey: "friendProfilePicture"))
        }
    }
    
    private func setupConstraints() {
        userProfileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(24)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView)
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(24)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.leading.trailing.equalTo(nameLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userProfileImageView.image = nil
    }
    
}
