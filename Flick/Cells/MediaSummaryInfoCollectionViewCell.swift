//
//  MediaSummaryCollectionViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaSummaryInfoCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let iconImageView = UIImageView()
    private let label = UILabel()
    private let spacerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .mediumGray
    }

    func configure(with mediaSummary: MediaSummary) {
        switch mediaSummary.type {
        case .spacer:
            setupSpacerView()
        case .duration:
            setUpLabelWithIcon(mediaSummary: mediaSummary)
        case .director:
            setUpLabelWithIcon(mediaSummary: mediaSummary)
        case .rating:
            setupLabelWithOutline(text: mediaSummary.text)
        default:
            setupLabel(text: mediaSummary.text)
        }
    }

    func setupSpacerView() {
        spacerView.layer.cornerRadius = 1
        spacerView.layer.backgroundColor = UIColor.lightGray.cgColor
        contentView.addSubview(spacerView)

        spacerView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(2)
        }
    }

    func setUpLabelWithIcon(mediaSummary: MediaSummary) {
        label.text = mediaSummary.text
        label.sizeToFit()
        contentView.addSubview(label)

        let iconImageName = mediaSummary.type == .director ? "director" : "film"
        iconImageView.image = UIImage(named: iconImageName)
        contentView.addSubview(iconImageView)

        iconImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.height.width.equalTo(15)
        }

        label.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(15)
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
        }
    }

    func setupLabelWithOutline(text: String) {
        setupLabel(text: text)
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2
        label.layer.borderColor = UIColor.mediumGray.cgColor
    }

    func setupLabel(text: String) {
        label.text = text
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

