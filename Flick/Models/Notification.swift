//
//  Notification.swift
//  Flick
//
//  Created by Lucy Xu on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

enum Notification {
    case FriendRequest(fromUser: String, type: FriendRequest.FriendRequestType)
    case CollaborationInvite(fromUser: String, media: String)
    case ListActivity(fromUser: String, list: String)
    case ActivityLike(fromUser: String, likedContent: ActivityLike.ActivityLikeType, media: String)
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
