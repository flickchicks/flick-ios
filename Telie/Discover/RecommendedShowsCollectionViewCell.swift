//
//  RecommendedShowsCollectionViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit
import Kingfisher

class RecommendedShowsCollectionViewCell: UICollectionViewCell {

    private let detailLabel = UILabel()
    private let imageView = UIImageView()
    private let listLabel = UILabel()
    private var mediaId: Int!
    private let userImageView = UIImageView()

    static let reuseIdentifier = "RecommendedShowsCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)

        userImageView.isHidden = true
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 10
        userImageView.layer.borderWidth = 1.5
        userImageView.layer.borderColor = UIColor.movieWhite.cgColor
        userImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        contentView.addSubview(userImageView)

        detailLabel.font = .boldSystemFont(ofSize: 14)
        detailLabel.textColor = .darkBlueGray2
        contentView.addSubview(detailLabel)

        listLabel.font = .systemFont(ofSize: 12)
        listLabel.textColor = .mediumGray
        contentView.addSubview(listLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 312, height: 468))
            make.top.leading.equalToSuperview()
        }

        userImageView.snp.makeConstraints { make in
            make.leading.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }

        detailLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.centerY.equalTo(userImageView)
            make.height.equalTo(17)
            make.trailing.equalToSuperview()
        }

        listLabel.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(detailLabel)
            make.height.equalTo(15)
        }
    }

    func configure(with media: SimpleMedia) {
        mediaId = media.id
        if let imageUrl = URL(string: media.posterPic ?? "defaultMovie") {
            imageView.kf.setImage(with: imageUrl)
        }
        if let savedToLsts = media.savedToLsts,
           savedToLsts.count > 0,
           let imageUrl = URL(string: savedToLsts[0].savedBy.profilePicUrl ?? "") {
                userImageView.isHidden = false
                let savedByUser = savedToLsts[0].savedBy
                userImageView.kf.setImage(with: imageUrl)
            detailLabel.text = "Saved by \(savedByUser.name)"
            listLabel.text = savedToLsts[0].lstName
        } else {
            userImageView.isHidden = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        userImageView.image = nil
        detailLabel.text = ""
        listLabel.text = ""
    }

}
