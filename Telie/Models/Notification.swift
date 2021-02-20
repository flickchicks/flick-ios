//
//  Notification.swift
//  Flick
//
//  Created by Lucy Xu on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//


struct Notification: Codable {
    var id: Int
    var notifType: String
    var fromUser: UserProfile
    var toUser: UserProfile
    var lst: NotificationMediaList?
    var newOwner: UserProfile?
    var numShowsAdded: Int?
    var numShowsRemoved: Int?
    var collaboratorsAdded: [UserProfile]
    var collaboratorsRemoved: [UserProfile]
    var friendRequestAccepted: Bool?
    var createdAt: String
}


enum NotificationEnum {
    case AcceptedIncomingFriendRequest(fromUser: UserProfile, createdAt: String)
    case AcceptedOutgoingFriendRequest(fromUser: UserProfile, createdAt: String)
    case IncomingFriendRequest(fromUser: UserProfile, createdAt: String)
    case CollaborationInvite(fromUser: UserProfile, list: NotificationMediaList, createdAt: String)
    case ListShowsEdit(fromUser: UserProfile, list: NotificationMediaList, type: ListEditType, numChanged: Int, createdAt: String)
    case ListCollaboratorsEdit(fromUser: UserProfile, list: NotificationMediaList, type: ListEditType, collaborators: [UserProfile], createdAt: String)
    case ListOwnershipEdit(fromUser: UserProfile, list: NotificationMediaList, newOwner: UserProfile, createdAt: String)
    case ActivityLike(fromUser: UserProfile, likedContent: ActivityLike.ActivityLikeType, media: String, createdAt: String)
}


enum ListEditType: String {
    case added = "added"
    case removed = "removed"
}

struct ActivityLike {

    enum ActivityLikeType {
        case comment
        case suggestion
    }

    let fromUser: String
    let likedContent: ActivityLikeType
    let media: String
}
