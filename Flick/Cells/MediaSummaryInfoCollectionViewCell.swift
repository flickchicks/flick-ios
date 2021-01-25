//
//  MediaSummaryCollectionViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaSummarySpacerCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let spacerView = UIView()
        spacerView.layer.cornerRadius = 1
        spacerView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        contentView.addSubview(spacerView)

        spacerView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(2)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MediaSummaryAudienceLevelCollectionViewCell: UICollectionViewCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .darkBlueGray2
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2
        label.layer.borderColor = UIColor.darkBlueGray2.cgColor
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with mediaSummary: MediaSummary) {
        label.text = mediaSummary.text
    }
}

class MediaSummaryIconLabelCollectionViewCell: UICollectionViewCell {

    private let iconImageView = UIImageView()
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .darkBlueGray2
        label.sizeToFit()
        contentView.addSubview(label)

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

    func configure(with mediaSummary: MediaSummary) {
        label.text = mediaSummary.text
        let iconImageName = mediaSummary.type == .director ? "director" : "film"
        iconImageView.image = UIImage(named: iconImageName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MediaSummaryLabelCollectionViewCell: UICollectionViewCell {
    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .darkBlueGray2
        contentView.addSubview(label)

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with mediaSummary: MediaSummary) {
       label.text = mediaSummary.text
    }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}
