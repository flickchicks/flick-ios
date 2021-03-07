//
//  RecommendedShowsCollectionViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

class RecommendedShowsCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Variables
    private let imageView = UIImageView()
    private let userImageView = UIImageView()
    private let detailLabel = UILabel()
    private var mediaId: Int!

    static let reuseIdentifier = "RecommendedShowsCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)

        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 10
        userImageView.layer.borderWidth = 1.5
        userImageView.layer.borderColor = UIColor.movieWhite.cgColor
        userImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        contentView.addSubview(userImageView)

        detailLabel.text = "Saved by Lucy"
        detailLabel.font = .boldSystemFont(ofSize: 14)
        detailLabel.textColor = .darkBlueGray2
        contentView.addSubview(detailLabel)

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

    }

    func configure(with media: SimpleMedia) {
        mediaId = media.id
        if let imageUrl = URL(string: media.posterPic ?? "defaultMovie") {
            self.imageView.kf.setImage(with: imageUrl)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}
