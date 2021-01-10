//
//  EditCollaboratorTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 1/6/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

protocol EditCollaboratorCellDelegate: class {
    func addCollaboratorTapped(user: UserProfile)
    func removeCollaboratorTapped(user: UserProfile)
}

class EditCollaboratorTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let editButton = UIButton()
    private let nameLabel = UILabel()
    private let userImageView = UIImageView()
    private let usernameLabel = UILabel()

    // MARK: - Private Data Vars
    weak var delegate: EditCollaboratorCellDelegate?
    private var isCollaborator: Bool?
    private var user: UserProfile?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.sizeToFit()
        contentView.addSubview(nameLabel)

        usernameLabel.font = .systemFont(ofSize: 12)
        usernameLabel.textColor = .mediumGray
        usernameLabel.sizeToFit()
        contentView.addSubview(usernameLabel)

        userImageView.layer.cornerRadius = 20
        userImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        contentView.addSubview(userImageView)

        editButton.setTitleColor(.mediumGray, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 14)
        editButton.backgroundColor = .lightGray2
        editButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        editButton.layer.cornerRadius = 11
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        contentView.addSubview(editButton)

        setupConstraints()
    }

    func configureFriend(for user: UserProfile, isAdded: Bool) {
        self.user = user
        self.isCollaborator = false
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.username)"
        if let pictureUrl = user.profilePic, let decodedData = NSData(base64Encoded: pictureUrl, options: []) {
            userImageView.image = UIImage(data: decodedData as Data)
        }
        if isAdded {
            editButton.isEnabled = false
            editButton.backgroundColor = .clear
            editButton.setTitle("Added", for: .normal)
            editButton.snp.updateConstraints { update in
                update.width.equalTo(68)
            }
        } else {
            editButton.isEnabled = true
            editButton.backgroundColor = .lightGray2
            editButton.setTitle("Add", for: .normal)
            editButton.snp.updateConstraints { update in
                update.width.equalTo(48)
            }
        }
    }

    func configureCollaborator(for user: UserProfile, isOwner: Bool) {
        self.user = user
        nameLabel.text = user.name
        if let pictureUrl = user.profilePic, let decodedData = NSData(base64Encoded: pictureUrl, options: []) {
            userImageView.image = UIImage(data: decodedData as Data)
        }
        if isOwner {
            usernameLabel.text = "Owner"
            editButton.isHidden = true
        } else {
            self.isCollaborator = true
            usernameLabel.text = "@\(user.username)"
            editButton.isHidden = false
            editButton.setTitle("Remove", for: .normal)
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
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.trailing.equalTo(editButton.snp.leading).offset(-10)
            make.top.equalTo(userImageView)
        }

        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }

        editButton.snp.makeConstraints { make in
            make.width.equalTo(74)
            make.height.equalTo(22)
            make.trailing.centerY.equalToSuperview()
        }
    }

    @objc func editButtonTapped() {
        guard let user = user, let isCollaborator = isCollaborator else { return }
        isCollaborator ? delegate?.removeCollaboratorTapped(user: user) : delegate?.addCollaboratorTapped(user: user)
    }

}
