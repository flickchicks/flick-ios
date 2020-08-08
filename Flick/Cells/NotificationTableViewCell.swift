//
//  NotificationTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    private let containerView = UIView()
    private let notificationLabel = UILabel()
    private let profileImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        backgroundColor = .offWhite

        // TODO: Double check shadow
        containerView.layer.backgroundColor = UIColor.movieWhite.cgColor
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = .init(width: 1, height: 1)
        containerView.layer.shadowRadius = 2
        containerView.sizeToFit()
        contentView.addSubview(containerView)

        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        containerView.addSubview(profileImageView)

        notificationLabel.font = .systemFont(ofSize: 14)
        notificationLabel.textColor = .black
        notificationLabel.numberOfLines = 0
        containerView.addSubview(notificationLabel)

        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalTo(containerView).inset(12)
            make.height.width.equalTo(40)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutNotificationLabel() {
        notificationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalTo(containerView).inset(12)
        }
    }

    private func setupFriendRequestCell(fromUser: String) {
        let friendLabelString = NSMutableAttributedString(string: fromUser, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        let friendRequestString = NSMutableAttributedString(string: " sent you a friend request")
        friendLabelString.append(friendRequestString)
        notificationLabel.attributedText = friendLabelString

        let acceptButton = UIButton()
        acceptButton.setTitle("Accept", for: .normal)
        acceptButton.titleLabel?.font = .systemFont(ofSize: 14)
        acceptButton.layer.backgroundColor = UIColor.lightPurple.cgColor
        acceptButton.setTitleColor(.gradientPurple, for: .normal)
        acceptButton.layer.cornerRadius = 17
        contentView.addSubview(acceptButton)

        let ignoreButton = UIButton()
        ignoreButton.setTitle("Ignore", for: .normal)
        ignoreButton.titleLabel?.font = .systemFont(ofSize: 14)
        ignoreButton.layer.backgroundColor = UIColor.lightGray2.cgColor
        ignoreButton.setTitleColor(.darkBlueGray2, for: .normal)
        ignoreButton.layer.cornerRadius = 17
        contentView.addSubview(ignoreButton)

        layoutNotificationLabel()

        let buttonSize = CGSize(width: 96, height: 41)

        profileImageView.snp.remakeConstraints { remake in
            remake.top.leading.equalTo(containerView).inset(12)
            remake.height.width.equalTo(40)
        }

        acceptButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.leading.equalTo(notificationLabel)
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(12)
        }

        ignoreButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.leading.equalTo(acceptButton.snp.trailing).offset(48)
            make.top.bottom.equalTo(acceptButton)
        }

    }

    private func setupFriendAcceptCell(fromUser: String) {
        let friendLabelString = NSMutableAttributedString(string: fromUser, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        let friendAcceptString = NSMutableAttributedString(string: " accepted your friend request ")
        friendLabelString.append(friendAcceptString)
        notificationLabel.attributedText = friendLabelString
        layoutNotificationLabel()
    }

    private func setupCollaborationInviteCell(fromUser: String, media: String) {
        let friendLabelString = NSMutableAttributedString(string: fromUser, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        let collaborationInviteString = NSMutableAttributedString(string: " invited you to collaborate on ")
        let listLabelString = NSMutableAttributedString(string: media, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        friendLabelString.append(collaborationInviteString)
        friendLabelString.append(listLabelString)
        notificationLabel.attributedText = friendLabelString
        layoutNotificationLabel()
    }

    private func setupActivityLikeCell(fromUser: String, likedContent: ActivityLike.ActivityLikeType, media: String) {
        let friendLabelString = NSMutableAttributedString(string: fromUser, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        let activityLikeString = NSMutableAttributedString(string: " liked your \(String(likedContent)) on ")
        let mediaLabelString = NSMutableAttributedString(string: media, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        friendLabelString.append(activityLikeString)
        friendLabelString.append(mediaLabelString)
        notificationLabel.attributedText = friendLabelString
        layoutNotificationLabel()
    }

    private func setupListActivityCell(fromUser: String, list: String) {
        let friendLabelString = NSMutableAttributedString(string: fromUser, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        let activityLikeString = NSMutableAttributedString(string: " added 3 items to ")
        let listLabelString = NSMutableAttributedString(string: list, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        friendLabelString.append(activityLikeString)
        friendLabelString.append(listLabelString)
        notificationLabel.attributedText = friendLabelString
        layoutNotificationLabel()
    }


    func configure(with notification: Notification) {

        switch notification {
        case .ActivityLike(let fromUser, let likedContent, let media):
            setupActivityLikeCell(fromUser: fromUser, likedContent: likedContent, media: media)
        case .ListActivity(let fromUser, let list):
            setupListActivityCell(fromUser: fromUser, list: list)
        case .FriendRequest(let fromUser, let type):
            switch type {
            case .received:
                setupFriendRequestCell(fromUser: fromUser)
            case .sent:
                setupFriendAcceptCell(fromUser: fromUser)
            }
        case .CollaborationInvite(let fromUser, let media):
            setupCollaborationInviteCell(fromUser: fromUser, media: media)
        }


    }

}
