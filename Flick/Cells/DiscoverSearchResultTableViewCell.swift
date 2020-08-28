//
//  DiscoverSearchResultTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 8/26/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class DiscoverSearchResultTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let infoStackView = UIStackView()
    private let subtitleStackView = UIStackView()

    private let resultImageView =  UIImageView()
    private let subtitleLabel = UILabel()
    private let titleLabel = UILabel()
    private let iconImageView = UIImageView()

    // MARK: - Private Data Vars

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .offWhite
        selectionStyle = .none

        infoStackView.axis = .vertical
        infoStackView.spacing = 5
        contentView.addSubview(infoStackView)

        titleLabel.text = "When they see us"
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        infoStackView.addArrangedSubview(titleLabel)

        subtitleStackView.axis = .horizontal
        subtitleStackView.spacing = 5
        infoStackView.addArrangedSubview(subtitleStackView)

        iconImageView.image = UIImage(named: "film")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        subtitleStackView.addArrangedSubview(iconImageView)

        subtitleLabel.text = "2020"
        subtitleLabel.textColor = .mediumGray
        subtitleLabel.font = .systemFont(ofSize: 10)
        subtitleStackView.addArrangedSubview(subtitleLabel)

        resultImageView.backgroundColor = .lightGray
        resultImageView.layer.masksToBounds = true
        resultImageView.layer.cornerRadius = 4
        contentView.addSubview(resultImageView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        resultImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(CGSize(width: 36, height: 54))
            make.top.bottom.equalToSuperview().inset(5)
            make.centerY.equalToSuperview()
        }

        infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(resultImageView.snp.trailing).offset(10)
//            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

    }
}
