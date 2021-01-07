//
//  NotificationTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let notificationLabel = UILabel()
    private let profileImageView = UIImageView()

    // MARK: - Private Data Vars
    private let padding = 12

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .offWhite

        containerView.layer.backgroundColor = UIColor.movieWhite.cgColor
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        containerView.layer.shadowOpacity = 0.07
        containerView.layer.shadowOffset = .init(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        contentView.addSubview(containerView)

        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        containerView.addSubview(profileImageView)

        notificationLabel.font = .systemFont(ofSize: 14)
        notificationLabel.textColor = .black
        notificationLabel.numberOfLines = 0
        containerView.addSubview(notificationLabel)

        containerView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(padding)
            make.bottom.equalTo(contentView)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(containerView).inset(padding)
            make.height.width.equalTo(40)
        }

        notificationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(padding)
            make.trailing.equalTo(containerView).inset(padding)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFriendAcceptCell(fromUser: String) {
        notificationLabel.attributedText =
            NSMutableAttributedString()
                .boldFont14(fromUser)
                .normalFont14(" accepted your friend request ")
    }

    private func setupCollaborationInviteCell(fromUser: String, media: String) {
        notificationLabel.attributedText =
            NSMutableAttributedString()
                .boldFont14(fromUser)
                .normalFont14(" invited you to collaborate on ")
                .boldFont14(media)
    }

    private func setupActivityLikeCell(fromUser: String, likedContent: ActivityLike.ActivityLikeType, media: String) {
        notificationLabel.attributedText =
            NSMutableAttributedString()
                .boldFont14(fromUser)
                .normalFont14(" liked your \(String(likedContent)) on ")
                .boldFont14(media)
    }

    private func setupListActivityCell(fromUser: String, list: String) {
        notificationLabel.attributedText =
        NSMutableAttributedString()
            .boldFont14(fromUser)
            .normalFont14(" added 3 items to ")
            .boldFont14(list)
    }


    func configure(with notification: Notification) {
        switch notification {
        case .ActivityLike(let fromUser, let likedContent, let media):
            setupActivityLikeCell(fromUser: fromUser, likedContent: likedContent, media: media)
        case .ListActivity(let fromUser, let list):
            setupListActivityCell(fromUser: fromUser, list: list)
        case .FriendRequest(let fromUser, let type):
            switch type {
            case .sent:
                setupFriendAcceptCell(fromUser: fromUser)
            case .received:
                return
            }
        case .CollaborationInvite(let fromUser, let media):
            setupCollaborationInviteCell(fromUser: fromUser, media: media)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

}
