//
//  BuzzTableViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit
import Kingfisher

class BuzzTableViewCell: UITableViewCell {

    private let profileImageView = UIImageView()
    private let buzzLabel = UILabel()
    private let commentTextView = UITextView()
    private let dateLabel = UILabel()
    private let summaryView = UIView()
    private let mediaImageView = UIImageView()
    private let mediaTitleLabel = UILabel()
    private let mediaDescriptionLabel = UILabel()

    static let reuseIdentifier = "BuzzTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.movieWhite.cgColor
        profileImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        contentView.addSubview(profileImageView)

        buzzLabel.textColor = .darkBlue
        buzzLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(buzzLabel)

        commentTextView.isEditable = false
        commentTextView.isScrollEnabled = false
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        commentTextView.layer.backgroundColor = UIColor.lightGray2.cgColor
        commentTextView.font = .systemFont(ofSize: 14)
        commentTextView.textColor = .darkBlue
        commentTextView.layer.cornerRadius = 16
        contentView.addSubview(commentTextView)

        dateLabel.text = "4d"
        dateLabel.textColor = .mediumGray
        dateLabel.font = .systemFont(ofSize: 10)
        contentView.addSubview(dateLabel)

        mediaImageView.layer.masksToBounds = true
        mediaImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        mediaImageView.layer.cornerRadius = 8
        summaryView.addSubview(mediaImageView)

        mediaTitleLabel.font = .boldSystemFont(ofSize: 14)
        mediaTitleLabel.textColor = .black
        mediaTitleLabel.numberOfLines = 0
        summaryView.addSubview(mediaTitleLabel)

        mediaDescriptionLabel.font = .systemFont(ofSize: 10)
        mediaDescriptionLabel.textColor = .darkBlue
        mediaDescriptionLabel.numberOfLines = 0
        summaryView.addSubview(mediaDescriptionLabel)

        summaryView.backgroundColor = .movieWhite
        summaryView.layer.cornerRadius = 12
        contentView.addSubview(summaryView)

        setupConstraints()

    }

    func configure(with comment: FriendComment) {
        profileImageView.kf.setImage(
            with: Base64ImageDataProvider(base64String: comment.owner.profilePic ?? "",
                                          cacheKey: "userid-\(comment.owner.id)"
            )
        )
        buzzLabel.text = "\(comment.owner.username) commented..."
        commentTextView.text = comment.message
        if let imageUrl = URL(string: comment.show.posterPic ?? "") {
            mediaImageView.kf.setImage(with: imageUrl)
        } else {
            mediaImageView.image = UIImage(named: "defaultMovie")
        }
        mediaTitleLabel.text = comment.show.title
        mediaDescriptionLabel.text = comment.show.plot ?? "No show plot."
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.leading.equalToSuperview().offset(23)
        }

        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(23)
            make.centerY.equalTo(buzzLabel)
            make.width.equalTo(22)
            make.height.equalTo(12)
        }

        summaryView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 271, height: 122))
            make.leading.equalTo(commentTextView)
            make.trailing.equalTo(dateLabel.snp.centerX)
            make.top.equalTo(commentTextView.snp.bottom).inset(8)
            make.bottom.equalToSuperview().inset(20)
        }

        mediaImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 90))
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(20)
        }

        mediaTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(mediaImageView.snp.trailing).offset(12)
            make.top.equalTo(mediaImageView).offset(3)
            make.trailing.equalToSuperview().inset(12)
        }

        mediaDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mediaTitleLabel.snp.bottom)
            make.leading.trailing.equalTo(mediaTitleLabel)
            make.bottom.equalToSuperview().inset(15)
        }

        commentTextView.snp.makeConstraints { make in
            make.leading.equalTo(buzzLabel)
            make.trailing.equalTo(dateLabel.snp.leading)
            make.top.equalTo(profileImageView.snp.bottom)
        }

        buzzLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.height.equalTo(17)
        }

    }

}
