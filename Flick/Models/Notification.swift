//
//  Notification.swift
//  Flick
//
//  Created by Lucy Xu on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//


struct BackendNotification: Codable {
    var id: Int
    var notifType: String
    var fromUser: UserProfile
    var toUser: UserProfile
    var lst: NotificationMediaList? // Double check this object!
    var newOwner: UserProfile?
    var numShowsAdded: Int?
    var numShowsRemoved: Int?
    var collaboratorsAdded: [UserProfile]
    var collaboratorsRemoved: [UserProfile]
    var friendRequestAccepted: Bool?
    var createdAt: String
}


enum Notification {
    case IncomingFriendRequest(fromUser: UserProfile)
    // Question: is accepted always true?
    case FriendRequest(fromUser: UserProfile, toUser: UserProfile)
    case CollaborationInvite(fromUser: UserProfile, list: NotificationMediaList)
    case ListShowsEdit(fromUser: UserProfile, list: NotificationMediaList, type: ListShowsEditType, numChanged: Int)
    case ListCollaboratorsEdit(fromUser: UserProfile, list: NotificationMediaList, type: ListShowsEditType, collaborators: [UserProfile])
    case ListOwnershipEdit(fromUser: UserProfile, list: NotificationMediaList, newOwner: UserProfile)
    case ActivityLike(fromUser: UserProfile, likedContent: ActivityLike.ActivityLikeType, media: String)
}


enum ListShowsEditType: String {
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
