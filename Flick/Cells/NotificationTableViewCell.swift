//
//  NotificationTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SkeletonView
import Kingfisher

class NotificationTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let dateLabel = UILabel()
    private let notificationLabel = UILabel()
    private let profileImageView = UIImageView()

    // MARK: - Data Vars
    private let padding = 12
    static var reuseIdentifier = "NotificationCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .offWhite
        isSkeletonable = true
    
        containerView.layer.cornerRadius = 16
        containerView.layer.backgroundColor = UIColor.movieWhite.cgColor
        containerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        containerView.layer.shadowOpacity = 0.07
        containerView.layer.shadowOffset = .init(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.isSkeletonable = true
        containerView.skeletonCornerRadius = 10
        contentView.addSubview(containerView)
        
        dateLabel.textAlignment = .right
        dateLabel.font = .systemFont(ofSize: 10)
        dateLabel.textColor = .mediumGray
        containerView.addSubview(dateLabel)

        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        containerView.addSubview(profileImageView)

        notificationLabel.font = .systemFont(ofSize: 14)
        notificationLabel.textColor = .black
        notificationLabel.numberOfLines = 0
        containerView.addSubview(notificationLabel)

        setupConstraints()
    }
    
    private func setupConstraints() {
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
            make.trailing.equalTo(dateLabel.snp.leading).offset(-padding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.height.equalTo(padding)
            make.trailing.equalTo(containerView).inset(padding)
            make.width.equalTo(30)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProfileImageView(user: UserProfile) {
        if let profilePic = user.profilePic {
            profileImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePic, cacheKey: "userid-\(user.id)"))
        }
    }

    /// setupAcceptedIncomingRequestCell sets notificationLabel for accepted incoming friend requests
    private func setupAcceptedIncomingRequestCell(from user: UserProfile, createdAt: String) {
        setupProfileImageView(user: user)
        setupDateLabel(createdAt: createdAt)
        notificationLabel.attributedText =
            NSMutableAttributedString()
            .normalFont14("You accepted ")
            .boldFont14(user.name)
            .normalFont14("'s friend request.")
    }
    
    /// setupAcceptedOutgoingRequestCell sets notificationLabel for accepted outgoing friend requests
    private func setupAcceptedOutgoingRequestCell(from user: UserProfile, createdAt: String) {
        setupProfileImageView(user: user)
        setupDateLabel(createdAt: createdAt)
        notificationLabel.attributedText =
            NSMutableAttributedString()
            .boldFont14(user.name)
            .normalFont14(" accepted your friend request.")
    }

    /// setupCollaborationInviteCell sets notificationLabel for list collaboration invites
    private func setupCollaborationInviteCell(fromUser: UserProfile, list: NotificationMediaList, createdAt: String) {
        setupProfileImageView(user: fromUser)
        setupDateLabel(createdAt: createdAt)
        notificationLabel.attributedText =
            NSMutableAttributedString()
            .boldFont14(fromUser.name)
            .normalFont14(" invited you to collaborate on ")
            .boldFont14(list.name)
            .normalFont14(".")
    }

    /// setupActivityLikeCell sets notificationLabel for liked activities
    //  TODO: Revisit this function after updates on backend
    private func setupActivityLikeCell(fromUser: UserProfile, likedContent: ActivityLike.ActivityLikeType, media: String, createdAt: String) {
        setupProfileImageView(user: fromUser)
        setupDateLabel(createdAt: createdAt)
        notificationLabel.attributedText =
            NSMutableAttributedString()
            .boldFont14(fromUser.name)
            .normalFont14(" liked your \(String(likedContent)) on ")
            .boldFont14(media)
            .normalFont14(".")
    }

    /// setupListShowsEditCell sets up notificationLabel from changes to shows in collaborated lists
    private func setupListShowsEditCell(fromUser: UserProfile, list: NotificationMediaList, type: ListEditType, numChanged: Int, createdAt: String) {
        setupProfileImageView(user: fromUser)
        setupDateLabel(createdAt: createdAt)
        let conjunction = type.rawValue == "added" ? "to" : "from"
        let posessiveTense = numChanged > 1 ? "s": ""
        notificationLabel.attributedText =
        NSMutableAttributedString()
            .boldFont14(fromUser.name)
            .normalFont14(" \(type) \(numChanged) item\(posessiveTense) \(conjunction) ")
            .boldFont14(list.name)
            .normalFont14(".")
    }
    
    /// setupListOwnershipEditCell sets up notificationLabel for changes in collaborated lists' ownership
    private func setupListOwnershipEditCell(fromUser: UserProfile, list: NotificationMediaList, newOwner: UserProfile, createdAt: String) {
        setupProfileImageView(user: fromUser)
        setupDateLabel(createdAt: createdAt)
        let newOwnerText = newOwner.id == UserDefaults.standard.integer(forKey: Constants.UserDefaults.userId) ? "you" : newOwner.name
        notificationLabel.attributedText =
        NSMutableAttributedString()
            .boldFont14(fromUser.name)
            .normalFont14(" made ")
            .boldFont14(newOwnerText)
            .normalFont14(" owner of ")
            .boldFont14(list.name)
            .normalFont14(".")
    }
    
    /// setupListCollaboratorsEdit sets up notificationLabel from changes to collaborators in collaborated lists
    private func setupListCollaboratorsEdit(fromUser: UserProfile, list: NotificationMediaList, type: ListEditType, collaborators: [UserProfile], createdAt: String) {
        setupProfileImageView(user: fromUser)
        setupDateLabel(createdAt: createdAt)
        let collaboratorNames = collaborators.map { $0.name }
        notificationLabel.attributedText =
        NSMutableAttributedString()
            .boldFont14(fromUser.name)
            .normalFont14(" \(type.rawValue) ")
            .boldFont14(collaboratorNames.joined(separator: ","))
            .normalFont14(" as collaborator\(collaborators.count > 1 ? "s" : "") on ")
            .boldFont14(list.name)
            .normalFont14(".")
    }
    
    private func setupDateLabel(createdAt: String){
        let dateLabelText = Date().getDateLabelText(createdAt: createdAt)
        dateLabel.text = dateLabelText
    }

    func configure(with notification: NotificationEnum) {
        switch notification {
        case .AcceptedIncomingFriendRequest(let fromUser, let createdAt):
            setupAcceptedIncomingRequestCell(from: fromUser, createdAt: createdAt)
        case .AcceptedOutgoingFriendRequest(let fromUser, let createdAt):
            setupAcceptedOutgoingRequestCell(from: fromUser, createdAt: createdAt)
        case .ActivityLike(let fromUser, let likedContent, let media, let createdAt):
            setupActivityLikeCell(fromUser: fromUser, likedContent: likedContent, media: media, createdAt: createdAt)
        case .ListShowsEdit(let fromUser, let list, let type, let numChanged, let createdAt):
            setupListShowsEditCell(fromUser: fromUser, list: list, type: type, numChanged: numChanged, createdAt: createdAt)
        case .ListOwnershipEdit(let fromUser, let list, let newOwner, let createdAt):
            setupListOwnershipEditCell(fromUser: fromUser, list: list, newOwner: newOwner, createdAt: createdAt)
        case .ListCollaboratorsEdit(let fromUser, let list, let type, let collaborators, let createdAt):
            setupListCollaboratorsEdit(fromUser: fromUser, list: list, type: type, collaborators: collaborators, createdAt: createdAt)
        case .CollaborationInvite(let fromUser, let media, let createdAt):
            setupCollaborationInviteCell(fromUser: fromUser, list: media, createdAt: createdAt)
        default:
            break
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

}
