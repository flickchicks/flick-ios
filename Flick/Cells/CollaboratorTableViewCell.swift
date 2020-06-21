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
    private let isSelectedIndicatorImageView = UIImageView()
    private let nameLabel = UILabel()
    private let roleLabel = UILabel()
    private let selectIndicatorImageView = UIImageView()
    private let userImageView = UIImageView()

    override var isSelected: Bool {
       didSet {

       }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .black
        addSubview(nameLabel)

        roleLabel.text = "Owner"
        roleLabel.isHidden = true
        roleLabel.font = .systemFont(ofSize: 16)
        roleLabel.textColor = .mediumGray
        addSubview(roleLabel)

        userImageView.layer.cornerRadius = 20
        userImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        addSubview(userImageView)

        selectIndicatorImageView.image = UIImage(named: "selectIndicator")
        addSubview(selectIndicatorImageView)

        isSelectedIndicatorImageView.image = UIImage(named: "isSelectedIndicator")
        isSelectedIndicatorImageView.isHidden = true
        addSubview(isSelectedIndicatorImageView)

        setupConstraints()
    }

    func configure(for collaborator: Collaborator) {
        nameLabel.text = collaborator.name
        userImageView.image = UIImage(named: collaborator.image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let isSelectedIndicatorSize = CGSize(width: 6, height: 8)
        let selectIndicatorSize = CGSize(width: 20, height: 20)
        let userImageSize = CGSize(width: 40, height: 40)

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(16)
            make.top.equalTo(userImageView)
        }

        roleLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }

        userImageView.snp.makeConstraints { make in
            make.size.equalTo(userImageSize)
            make.centerY.leading.equalToSuperview()
        }

        selectIndicatorImageView.snp.makeConstraints { make in
            make.size.equalTo(selectIndicatorSize)
            make.centerY.trailing.equalToSuperview()
        }

        isSelectedIndicatorImageView.snp.makeConstraints { make in
            make.center.equalTo(selectIndicatorImageView)
            make.size.equalTo(isSelectedIndicatorSize)
        }

    }

}

