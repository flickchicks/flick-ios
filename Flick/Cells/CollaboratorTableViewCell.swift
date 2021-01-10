//
//  CollaboratorTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 6/21/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class CollaboratorTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let nameLabel = UILabel()
    private let ownerLabel = UILabel()
    private let selectIndicatorView = SelectIndicatorView(width: 20)
    private let userImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .black
        addSubview(nameLabel)

        ownerLabel.text = "Owner"
        ownerLabel.font = .systemFont(ofSize: 16)
        ownerLabel.textColor = .mediumGray

        userImageView.layer.cornerRadius = 20
        userImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        addSubview(userImageView)

        selectIndicatorView.layer.backgroundColor = UIColor.white.cgColor
        selectIndicatorView.isHidden = true
        addSubview(selectIndicatorView)

        setupConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectIndicatorView.select()
        } else {
            selectIndicatorView.deselect()
        }
    }

    func configure(for collaborator: UserProfile, isOwner: Bool) {
        nameLabel.text = collaborator.name
        if let pictureUrl = collaborator.profilePic, let decodedData = NSData(base64Encoded: pictureUrl, options: []) {
            userImageView.image = UIImage(data: decodedData as Data)
        }
        if isOwner {
            addSubview(ownerLabel)
            setupOwnerConstraints()
            selectIndicatorView.isHidden = true
        } else {
            setupNonOwnerConstraints()
//            collaborator.isAdded ? selectIndicatorView.select() : selectIndicatorView.deselect()
            selectIndicatorView.isHidden = false
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let selectIndicatorSize = CGSize(width: 20, height: 20)
        let userImageSize = CGSize(width: 40, height: 40)

        userImageView.snp.makeConstraints { make in
            make.size.equalTo(userImageSize)
            make.centerY.leading.equalToSuperview()
        }

        selectIndicatorView.snp.makeConstraints { make in
            make.size.equalTo(selectIndicatorSize)
            make.centerY.trailing.equalToSuperview()
        }
    }

    private func setupOwnerConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(16)
            make.top.equalTo(userImageView)
        }

        ownerLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
    }

    private func setupNonOwnerConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }

}
