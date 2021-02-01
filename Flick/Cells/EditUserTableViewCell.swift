//
//  EditUserTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 1/6/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit
import Kingfisher

protocol EditUserCellDelegate: class {
    func addUserTapped(user: UserProfile)
    func removeUserTapped(user: UserProfile)
}

class EditUserTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let editButton = UIButton()
    private let nameLabel = UILabel()
    private let userImageView = UIImageView()
    private let usernameLabel = UILabel()

    // MARK: - Data Vars
    weak var delegate: EditUserCellDelegate?
    private var isAddUser: Bool?
    static let reuseIdentifier = "EditUserCellReuseIdentifier"
    private var user: UserProfile?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.sizeToFit()
        contentView.addSubview(nameLabel)

        usernameLabel.font = .systemFont(ofSize: 14)
        usernameLabel.textColor = .mediumGray
        usernameLabel.sizeToFit()
        contentView.addSubview(usernameLabel)

        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 20
        userImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        contentView.addSubview(userImageView)

        editButton.setTitleColor(.darkBlueGray2, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        editButton.backgroundColor = .lightGray2
        editButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        editButton.layer.cornerRadius = 12.5
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        contentView.addSubview(editButton)

        setupConstraints()
    }

    func configureForAdd(user: UserProfile, isAdded: Bool) {
        self.user = user
        self.isAddUser = true
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.username)"
        if let profilePic = user.profilePic {
            userImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePic, cacheKey: "userid-\(user.id)"))
        }
        if isAdded {
            editButton.isEnabled = false
            editButton.backgroundColor = .clear
            editButton.setTitle("Added", for: .normal)
            editButton.layer.borderWidth = 0
            editButton.snp.updateConstraints { update in
                update.width.equalTo(68)
            }
        } else {
            editButton.isEnabled = true
            editButton.backgroundColor = .lightGray2
            editButton.setTitle("Add", for: .normal)
            editButton.layer.borderWidth = 1
            editButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
            editButton.snp.updateConstraints { update in
                update.width.equalTo(48)
            }
        }
    }

    func configureForRemove(user: UserProfile, isOwner: Bool) {
        self.user = user
        nameLabel.text = user.name
        if let profilePic = user.profilePic {
            userImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePic, cacheKey: "userid-\(user.id)"))
        }
        if isOwner {
            usernameLabel.text = "Owner"
            editButton.isHidden = true
        } else {
            self.isAddUser = false
            usernameLabel.text = "@\(user.username)"
            editButton.isHidden = false
            editButton.setTitle("Remove", for: .normal)
            editButton.layer.borderWidth = 1
            editButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
            editButton.snp.updateConstraints { update in
                update.width.equalTo(74)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let userImageSize = CGSize(width: 40, height: 40)

        userImageView.snp.makeConstraints { make in
            make.size.equalTo(userImageSize)
            make.centerY.leading.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(12)
            make.trailing.equalTo(editButton.snp.leading).offset(-10)
            make.top.equalTo(userImageView)
        }

        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }

        editButton.snp.makeConstraints { make in
            make.width.equalTo(74)
            make.height.equalTo(25)
            make.trailing.centerY.equalToSuperview()
        }
    }

    @objc func editButtonTapped() {
        guard let user = user, let isAddUser = isAddUser else { return }
        isAddUser ? delegate?.addUserTapped(user: user) : delegate?.removeUserTapped(user: user)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }

}
