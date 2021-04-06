//
//  RecommendedListsCollectionViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit
import Kingfisher

class RecommendedListsCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Variables
    private let detailLabel = UILabel()
    private let listImageView = UIImageView()
    private let listLabel = UILabel()
    private let mediaOneImageView = UIImageView()
    private let mediaTwoImageView = UIImageView()
    private let mediaThreeImageView = UIImageView()
    private var mediaId: Int!
    private let userImageView = UIImageView()

    static let reuseIdentifier = "RecommendedListsCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        mediaOneImageView.layer.cornerRadius = 12
        mediaOneImageView.image = UIImage(named: "defaultMovie")
        mediaOneImageView.clipsToBounds = true
        mediaOneImageView.layer.masksToBounds = true
        mediaOneImageView.contentMode = .scaleAspectFill
        mediaOneImageView.layer.borderColor = UIColor.movieWhite.cgColor
        mediaOneImageView.layer.borderWidth = 1.5
        contentView.addSubview(mediaOneImageView)

        mediaTwoImageView.layer.cornerRadius = 12
        mediaTwoImageView.image = UIImage(named: "defaultMovie")
        mediaTwoImageView.clipsToBounds = true
        mediaTwoImageView.layer.masksToBounds = true
        mediaTwoImageView.contentMode = .scaleAspectFill
        mediaTwoImageView.layer.borderWidth = 1.5
        mediaTwoImageView.layer.borderColor = UIColor.movieWhite.cgColor

        contentView.addSubview(mediaTwoImageView)

        mediaThreeImageView.layer.cornerRadius = 12
        mediaThreeImageView.image = UIImage(named: "defaultMovie")
        mediaThreeImageView.clipsToBounds = true
        mediaThreeImageView.layer.masksToBounds = true
        mediaThreeImageView.contentMode = .scaleAspectFill
        mediaThreeImageView.layer.borderWidth = 1.5
        mediaThreeImageView.layer.borderColor = UIColor.movieWhite.cgColor

        contentView.addSubview(mediaThreeImageView)

        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 10
        userImageView.layer.borderWidth = 1.5
        userImageView.layer.borderColor = UIColor.movieWhite.cgColor
        userImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        contentView.addSubview(userImageView)

        detailLabel.font = .boldSystemFont(ofSize: 14)
        detailLabel.textColor = .darkBlueGray2
        contentView.addSubview(detailLabel)

        listImageView.image = UIImage(named: "listIcon")
        contentView.addSubview(listImageView)

        listLabel.font = .systemFont(ofSize: 12)
        listLabel.textColor = .mediumGray
        contentView.addSubview(listLabel)

        setupConstraints()
    }

    private func setupConstraints() {

        mediaOneImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 312, height: 468))
            make.top.trailing.equalToSuperview()
        }

        mediaTwoImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 312, height: 468))
            make.top.trailing.equalTo(mediaOneImageView).inset(10)
        }

        mediaThreeImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 312, height: 468))
            make.top.trailing.equalTo(mediaTwoImageView).inset(10)
        }

        userImageView.snp.makeConstraints { make in
            make.leading.equalTo(mediaThreeImageView)
            make.top.equalTo(mediaThreeImageView.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }

        detailLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.centerY.equalTo(userImageView)
            make.height.equalTo(17)
            make.trailing.equalToSuperview()
        }

        listImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 10, height: 14))
            make.leading.equalTo(detailLabel)
            make.centerY.equalTo(listLabel)
        }

        listLabel.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(4)
            make.trailing.equalTo(detailLabel)
            make.leading.equalTo(listImageView.snp.trailing).offset(4)
            make.height.equalTo(15)
        }
        
    }

    func configure(with list: MediaList) {
        if list.shows.count >= 3,
           let imageUrl1 = URL(string: list.shows[2].posterPic ?? "defaultMovie") {
            mediaOneImageView.kf.setImage(with: imageUrl1)
        }

        if list.shows.count >= 2,
           let imageUrl2 = URL(string: list.shows[1].posterPic ?? "defaultMovie") {
            mediaTwoImageView.kf.setImage(with: imageUrl2)
        }

        if list.shows.count >= 1,
           let imageUrl3 = URL(string: list.shows[0].posterPic ?? "defaultMovie") {
            mediaThreeImageView.kf.setImage(with: imageUrl3)
        }

        if let profilePicUrl = list.owner.profilePicUrl,
           let imageUrl = URL(string: profilePicUrl) {
            userImageView.kf.setImage(with: imageUrl)
        }

        detailLabel.text = "Created by \(list.owner.name)"
        if list.numLikes > 0 {
            listLabel.text = "\(list.name) • \(list.numLikes) Like\(list.numLikes > 1 ? "s": "")"
        } else {
            listLabel.text = "\(list.name)"
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mediaOneImageView.image = UIImage(named: "defaultMovie")
        mediaTwoImageView.image = UIImage(named: "defaultMovie")
        mediaThreeImageView.image = UIImage(named: "defaultMovie")
        userImageView.image = nil
    }

}
