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

    // Current user accepted incoming friend request
    private func setupAcceptedIncomingRequestCell(from user: UserProfile) {
        notificationLabel.attributedText =
            NSMutableAttributedString()
            .normalFont14("You accepted ")
            .boldFont14(user.name)
            .normalFont14("'s friend request.")
    }
    
    // User accepted current user's outgoing friend request
    private func setupAcceptedOutgoingRequestCell(to user: UserProfile) {
        notificationLabel.attributedText =
            NSMutableAttributedString()
            .boldFont14(user.name)
            .normalFont14(" accepted your friend request.")
    }

    private func setupCollaborationInviteCell(fromUser: UserProfile, list: NotificationMediaList) {
        notificationLabel.attributedText =
            NSMutableAttributedString()
            .boldFont14(fromUser.name)
            .normalFont14(" invited you to collaborate on ")
            .boldFont14(list.name)
            .normalFont14(".")
    }

    private func setupActivityLikeCell(fromUser: UserProfile, likedContent: ActivityLike.ActivityLikeType, media: String) {
        notificationLabel.attributedText =
            NSMutableAttributedString()
            .boldFont14(fromUser.name)
            .normalFont14(" liked your \(String(likedContent)) on ")
            .boldFont14(media)
            .normalFont14(".")
    }

    private func setupListShowsEditCell(fromUser: UserProfile, list: NotificationMediaList, type: ListShowsEditType, numChanged: Int) {
        let editConjunctionTerm = type.rawValue == "added" ? "to" : "from"
        let editPluralTerm = numChanged > 1 ? "s": ""
        notificationLabel.attributedText =
        NSMutableAttributedString()
            .boldFont14(fromUser.name)
            .normalFont14(" \(type) \(numChanged) item\(editPluralTerm) \(editConjunctionTerm) ")
            .boldFont14(list.name)
    }
    
    private func setupListOwnershipEditCell(fromUser: UserProfile, list: NotificationMediaList, newOwner: UserProfile) {
        let newOwnerText = newOwner.id == UserDefaults.standard.integer(forKey: Constants.UserDefaults.userId) ? NSMutableAttributedString().normalFont14("you") : NSMutableAttributedString().boldFont14(newOwner.name)
        notificationLabel.attributedText =
        NSMutableAttributedString()
            .boldFont14(fromUser.name)
            .normalFont14(" made ")
            newOwnerText
            .normalFont14(" owner of ")
            .boldFont14(list.name)
            .normalFont14(".")
    }

    func configure(with notification: Notification) {
        switch notification {
        case .ActivityLike(let fromUser, let likedContent, let media):
            setupActivityLikeCell(fromUser: fromUser, likedContent: likedContent, media: media)
        case .ListShowsEdit(let fromUser, let list, let type, let numChanged):
            setupListShowsEditCell(fromUser: fromUser, list: list, type: type, numChanged: numChanged)
        case .ListOwnershipEdit(let fromUser, let list, let newOwner):
            setupListOwnershipEditCell(fromUser: fromUser, list: list, newOwner: newOwner)
        case .FriendRequest(let fromUser, let toUser):
            if toUser.id == UserDefaults.standard.integer(forKey: Constants.UserDefaults.userId) {
                setupAcceptedIncomingRequestCell(from: fromUser)
            } else {
                setupAcceptedOutgoingRequestCell(to: toUser)
            }
        case .CollaborationInvite(let fromUser, let media):
            setupCollaborationInviteCell(fromUser: fromUser, list: media)
        default:
            break
        }
    }

}
