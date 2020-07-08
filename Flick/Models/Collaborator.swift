//
//  Collaborator.swift
//  Flick
//
//  Created by Lucy Xu on 6/21/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation

class Collaborator {

    var name: String
    var isOwner: Bool
    var image: String
    var isAdded: Bool

    init(name: String, isOwner: Bool, image: String, isAdded: Bool) {
        self.name = name
        self.isOwner = isOwner
        self.image = image
        self.isAdded = isAdded
    }

}

//struct BackendCollaborator: Codable {
//    var userId: String
//    var username: String
//    var firstName: String
//    var lastName: String
//    var profileId: String
//    var profilePic: ProfilePicture
//}
