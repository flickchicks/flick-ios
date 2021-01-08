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
    var lst: MediaList? // Double check this object!
    var newOwner: UserProfile?
    var numShowsAdded: String?
    var numShowsRemoved: String?
    var collaboratorsAdded: [UserProfile]
    var collaboratorsRemoved: [UserProfile]
    var friendRequestAccepted: Bool
    var createdAt: String
}


enum Notification {
    case FriendRequest(fromUser: UserProfile, type: FriendRequest.FriendRequestType)
    case CollaborationInvite(fromUser: UserProfile, media: String)
    case ListActivity(fromUser: UserProfile, list: String)
    case ActivityLike(fromUser: UserProfile, likedContent: ActivityLike.ActivityLikeType, media: String)
}


struct FriendRequest {

    enum FriendRequestType {
        case sent
        case received
    }

    let fromUser: String
    let type: FriendRequestType
}

struct CollaborationInvite {
    let fromUser: String
    let media: String
}

struct ListActivity {
    let fromUser: String
    let list: String
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

