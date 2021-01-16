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
    case AcceptedIncomingFriendRequest(fromUser: UserProfile)
    case AcceptedOutgoingFriendRequest(fromUser: UserProfile)
    case IncomingFriendRequest(fromUser: UserProfile)
    case CollaborationInvite(fromUser: UserProfile, list: NotificationMediaList)
    case ListShowsEdit(fromUser: UserProfile, list: NotificationMediaList, type: ListEditType, numChanged: Int)
    case ListCollaboratorsEdit(fromUser: UserProfile, list: NotificationMediaList, type: ListEditType, collaborators: [UserProfile])
    case ListOwnershipEdit(fromUser: UserProfile, list: NotificationMediaList, newOwner: UserProfile)
    case ActivityLike(fromUser: UserProfile, likedContent: ActivityLike.ActivityLikeType, media: String)
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
