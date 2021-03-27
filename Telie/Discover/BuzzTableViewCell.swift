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
    private let mediaDetailLabel = UILabel()
    private let mediaImageView = UIImageView()
    private let mediaTitleLabel = UILabel()
    private let mediaDescriptionLabel = UILabel()

    private var show: SimpleMedia?
    private var user: UserProfile?

    weak var discoverDelegate: DiscoverDelegate?
    static let reuseIdentifier = "BuzzTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        let profileTapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleProfileTap)
        )
        profileImageView.addGestureRecognizer(profileTapGestureRecognizer)

        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.borderWidth = 1.5
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.borderColor = UIColor.movieWhite.cgColor
        profileImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        contentView.addSubview(profileImageView)

        contentView.addSubview(buzzLabel)

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

        mediaDetailLabel.font = .systemFont(ofSize: 12)
        mediaDetailLabel.textColor = .mediumGray
        summaryView.addSubview(mediaDetailLabel)

        mediaDescriptionLabel.font = .systemFont(ofSize: 10)
        mediaDescriptionLabel.textColor = .darkBlue
        mediaDescriptionLabel.numberOfLines = 0
        summaryView.addSubview(mediaDescriptionLabel)

        let summaryTapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleCommentTap)
        )
        summaryView.backgroundColor = .movieWhite
        summaryView.layer.cornerRadius = 12
        summaryView.isUserInteractionEnabled = true
        summaryView.addGestureRecognizer(summaryTapGestureRecognizer)
        contentView.addSubview(summaryView)


        let commentTapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handleCommentTap)
        )
        commentTextView.isEditable = false
        commentTextView.isScrollEnabled = false
        commentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        commentTextView.layer.backgroundColor = UIColor.lightGray2.cgColor
        commentTextView.font = .systemFont(ofSize: 14)
        commentTextView.textColor = .darkBlue
        commentTextView.isUserInteractionEnabled = true
        commentTextView.layer.cornerRadius = 16
        commentTextView.addGestureRecognizer(commentTapGestureRecognizer)
        contentView.addSubview(commentTextView)

        setupConstraints()
    }

    func configure(with comment: Comment) {
        show = comment.show
        user = comment.owner

        if let imageUrl = URL(string: comment.owner.profilePicUrl ?? "") {
            profileImageView.kf.setImage(with: imageUrl)
        }

        buzzLabel.attributedText =
            NSMutableAttributedString()
            .boldFont14(comment.owner.username)
            .normalFont14(" commented...")
        commentTextView.text = comment.message
        if let imageUrl = URL(string: comment.show?.posterPic ?? "") {
            mediaImageView.kf.setImage(with: imageUrl)
        } else {
            mediaImageView.image = UIImage(named: "defaultMovie")
        }
        mediaTitleLabel.text = comment.show?.title
        let tags = comment.show?.tags?.map { $0.name }
        mediaDetailLabel.text = tags?.prefix(2).joined(separator: ", ")
        mediaDescriptionLabel.text = comment.show?.plot ?? "No show plot."
        dateLabel.text = Date().getDateLabelText(createdAt: comment.createdAt)
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

        mediaDetailLabel.snp.makeConstraints { make in
            make.top.equalTo(mediaTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(mediaTitleLabel)
            make.height.equalTo(15)
        }

        mediaDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mediaDetailLabel.snp.bottom).offset(8)
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

    @objc func handleProfileTap() {
        guard let user = user else { return }
        discoverDelegate?.navigateFriend(id: user.id)
    }

    @objc func handleCommentTap() {
        guard let show = show else { return }
        discoverDelegate?.navigateShow(id: show.id, mediaImageUrl: show.posterPic)
    }
}
