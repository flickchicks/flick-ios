//
//  EditUserTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 1/6/21.
//  Copyright © 2021 flick. All rights reserved.
//

import Kingfisher
import NVActivityIndicatorView
import UIKit

protocol EditUserCellDelegate: class {
    func addUserTapped(user: UserProfile)
    func removeUserTapped(user: UserProfile)
}

class EditUserTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let editButton = UIButton()
    private let editLabel = UILabel()
    private let nameLabel = UILabel()
    private let profileImageView = UIImageView()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let usernameLabel = UILabel()

    // MARK: - Data Vars
    weak var delegate: EditUserCellDelegate?
    private var editMode = CollaboratorEditMode.add
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

        profileImageView.kf.setImage(with: URL(string: Constants.User.defaultImage))
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        contentView.addSubview(profileImageView)

        editButton.setTitleColor(.darkBlueGray2, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        editButton.titleLabel?.textAlignment = .center
        editButton.backgroundColor = .lightGray2
        editButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        editButton.layer.cornerRadius = 12.5
        editButton.layer.borderWidth = 1
        editButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        contentView.addSubview(editButton)

        editLabel.font = .systemFont(ofSize: 14, weight: .medium)
        editLabel.textColor = .mediumGray
        editLabel.textAlignment = .right
        editLabel.isHidden = true
        contentView.addSubview(editLabel)

        contentView.addSubview(spinner)

        setupConstraints()
    }

    func configureUser(user: UserProfile, editMode: CollaboratorEditMode) {
        self.user = user
        self.editMode = editMode
        nameLabel.text = user.name
        usernameLabel.text = "@\(user.username)"
        if let imageUrl = URL(string: user.profilePicUrl ?? Constants.User.defaultImage) {
            profileImageView.kf.setImage(with: imageUrl)
        }
    }

    func configureForAdd(user: UserProfile, editMode: CollaboratorEditMode, isAdded: Bool) {
        configureUser(user: user, editMode: editMode)
        if isAdded {
            editButton.isHidden = true
            editLabel.isHidden = false
            editLabel.text = "Added"
        } else {
            editButton.setTitle("Add", for: .normal)
            editButton.snp.updateConstraints { update in
                update.width.equalTo(48)
            }
        }
    }

    func configureForRemove(user: UserProfile, editMode: CollaboratorEditMode, isOwner: Bool) {
        configureUser(user: user, editMode: editMode)
        if isOwner {
            usernameLabel.text = "Owner"
            editButton.isHidden = true
        } else {
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
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.centerY.leading.equalToSuperview()
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalTo(editButton.snp.leading).offset(-10)
            make.top.equalTo(profileImageView)
        }

        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }

        editLabel.snp.makeConstraints  { make in
            make.edges.equalTo(editButton)
        }

        spinner.snp.makeConstraints  { make in
            make.edges.equalTo(editButton)
        }

        editButton.snp.makeConstraints { make in
            make.width.equalTo(74)
            make.height.equalTo(25)
            make.trailing.centerY.equalToSuperview()
        }
    }

    @objc func editButtonTapped() {
        guard let user = user else { return }
        spinner.startAnimating()
        editButton.isHidden = true
        editMode == .add ? delegate?.addUserTapped(user: user) : delegate?.removeUserTapped(user: user)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.kf.setImage(with: URL(string: Constants.User.defaultImage))
        editButton.isHidden = false
        editLabel.isHidden = true
        spinner.stopAnimating()
    }

}
