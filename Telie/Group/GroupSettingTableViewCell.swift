//
//  GroupSettingTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 1/27/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class GroupSettingTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let descriptionLabel = UILabel()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: - Data Vars
    static let reuseIdentifier = "GroupSettingCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .offWhite

        containerView.backgroundColor = .lightGray2
        containerView.layer.cornerRadius = 8
        contentView.addSubview(containerView)

        descriptionLabel.textColor = .mediumGray
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)

        iconImageView.contentMode = .scaleAspectFill
        containerView.addSubview(iconImageView)

        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        containerView.addSubview(titleLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalTo(containerView)
        }

        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }

    func configure(descriptionText: String?, icon: String, textColor: UIColor, title: String) {
        if let descriptionText = descriptionText {
            descriptionLabel.text = descriptionText
        }
        iconImageView.image = UIImage(named: icon)
        titleLabel.textColor = textColor
        titleLabel.text = title
    }

    override func prepareForReuse() {
        descriptionLabel.text = nil
    }

}
