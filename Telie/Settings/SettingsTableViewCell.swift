//
//  SettingsTableViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 4/12/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import Kingfisher
import NVActivityIndicatorView
import UIKit

class SettingsTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    // MARK: - Data Vars
    static let reuseIdentifier = "SettingsTableViewCell"


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(iconImageView)

        titleLabel.font = .systemFont(ofSize: 18)
        contentView.addSubview(titleLabel)

        setupConstraints()
    }

    func configure(with settingOption: SettingsOption) {
        titleLabel.text = settingOption.rawValue
        titleLabel.textColor = settingOption.color
        iconImageView.image = settingOption.image
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(8)
        }

    }

}
