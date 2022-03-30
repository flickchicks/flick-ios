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
    private let listImageView = UIImageView()
    private let listLabel = UILabel()
    private let userImageView = UIImageView()

    weak var discoverDelegate: DiscoverDelegate?
    private var media: SimpleMedia?
    static let reuseIdentifier = "RecommendedShowsCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        let mediaTapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleMediaTap)
        )
        imageView.addGestureRecognizer(mediaTapGestureRecognizer)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "defaultMovie")
        imageView.isUserInteractionEnabled = true
        contentView.addSubview(imageView)

        let userTapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleUserTap)
        )
        userImageView.addGestureRecognizer(userTapGestureRecognizer)
        userImageView.isHidden = true
        userImageView.contentMode = .scaleAspectFill
        userImageView.isUserInteractionEnabled = true
        userImageView.layer.masksToBounds = true
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 10
        userImageView.layer.borderWidth = 1.5
        userImageView.layer.borderColor = UIColor.movieWhite.cgColor
        userImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        contentView.addSubview(userImageView)

        let detailTapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleUserTap)
        )
        detailLabel.addGestureRecognizer(detailTapGestureRecognizer)
        detailLabel.font = .boldSystemFont(ofSize: 14)
        detailLabel.textColor = .darkBlueGray2
        detailLabel.isUserInteractionEnabled = true
        contentView.addSubview(detailLabel)

        listImageView.image = UIImage(named: "listIcon")
        contentView.addSubview(listImageView)

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

    func configure(with media: SimpleMedia) {
        self.media = media
        if let posterPic = media.posterPic,
           let imageUrl = URL(string: posterPic) {
            imageView.kf.setImage(with: imageUrl)
        }
        if let savedToLsts = media.savedToLsts,
           savedToLsts.count > 0 {
            userImageView.isHidden = false
            let savedByUser = savedToLsts[0].savedBy
            if let profilePicUrl = savedToLsts[0].savedBy.profilePicUrl,
            let imageUrl = URL(string: profilePicUrl) {
                userImageView.kf.setImage(with: imageUrl)
            }
            detailLabel.text = "Saved by \(savedByUser.name)"
            listLabel.text = savedToLsts[0].lstName
        } else {
            userImageView.isHidden = true
            listImageView.isHidden = true
        }
    }

    @objc func handleMediaTap() {
        guard let media = media else { return }
        discoverDelegate?.navigateShow(id: media.id, mediaName: media.title)
        AnalyticsManager.logSelectContent(
            contentType: SelectContentType.Discover.showSuggestion,
            itemId: media.id
        )
    }

    @objc func handleUserTap() {
        guard let media = media,
              let savedToLsts = media.savedToLsts,
              savedToLsts.count > 0 else { return }
        let user = savedToLsts[0].savedBy
        discoverDelegate?.navigateFriend(id: user.id)
        AnalyticsManager.logSelectContent(
            contentType: SelectContentType.Discover.showSuggestion,
            itemId: media.id
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "defaultMovie")
        userImageView.image = nil
        detailLabel.text = ""
        listLabel.text = ""
    }

}
