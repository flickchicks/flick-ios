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
    private let iconImageView = UIImageView()
    private let infoStackView = UIStackView()
    private let listPreviewView = ListPreviewView()
    private let resultImageView =  UIImageView()
    private let subtitleLabel = UILabel()
    private let subtitleStackView = UIStackView()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let circleImageViewSize = CGSize(width: 36, height: 36)
    private let listPreviewSize = CGSize(width: 37, height: 48)
    private let posterImageViewSize = CGSize(width: 36, height: 54)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .offWhite
        selectionStyle = .none

        infoStackView.axis = .vertical
        infoStackView.spacing = 5
        contentView.addSubview(infoStackView)

        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        infoStackView.addArrangedSubview(titleLabel)

        subtitleStackView.axis = .horizontal
        subtitleStackView.spacing = 5
        infoStackView.addArrangedSubview(subtitleStackView)

        let iconSize = CGSize(width: 14, height: 14)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
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

        listPreviewView.isHidden = true
        contentView.addSubview(listPreviewView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(searchType: SearchTab, titleText: String) {
        titleLabel.text = titleText
        switch searchType {
        case .lists:
            resultImageView.isHidden = true
            iconImageView.isHidden = true
            listPreviewView.isHidden = false
            setupConstraintsForListPreview()
            subtitleLabel.text = "by Lucy Xu" // Temp
        case .movies:
            updateConstraintsForPoster()
            resultImageView.image = UIImage(named: "dunkirk") // Temp
            iconImageView.image = UIImage(named: "film")
        case .people:
            updateConstraintsForCircleImage()
            resultImageView.layer.cornerRadius = circleImageViewSize.width / 2
            iconImageView.isHidden = true
            subtitleLabel.text = "3 mutual friends" // Temp
        case .shows:
            resultImageView.image = UIImage(named: "dunkirk") // Temp
            updateConstraintsForPoster()
            iconImageView.image = UIImage(named: "tv")
        case .tags:
            updateConstraintsForCircleImage()
            resultImageView.layer.cornerRadius = circleImageViewSize.width / 2
            resultImageView.image = UIImage(named: "tag")
            subtitleStackView.isHidden = true
        case .top:
            iconImageView.image = UIImage(named: "film")
        }
    }

    private func setupConstraints() {
        resultImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(posterImageViewSize)
            make.top.bottom.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }

        infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(resultImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    private func updateConstraintsForPoster() {
        resultImageView.snp.updateConstraints { update in
            update.size.equalTo(posterImageViewSize)
        }
    }

    private func updateConstraintsForCircleImage() {
        resultImageView.snp.updateConstraints { update in
            update.size.equalTo(circleImageViewSize)
        }
    }

    private func setupConstraintsForListPreview() {
        listPreviewView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(listPreviewSize)
            make.top.bottom.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }

        infoStackView.snp.makeConstraints { remake in
            remake.leading.equalTo(listPreviewView.snp.trailing).offset(10)
            remake.trailing.equalToSuperview()
            remake.centerY.equalToSuperview()
        }
    }
}
