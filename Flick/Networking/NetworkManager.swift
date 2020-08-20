//
//  NetworkManager.swift
//  Flick
//
//  Created by Lucy Xu on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {

    static let shared: NetworkManager = NetworkManager()

    static let headers: HTTPHeaders = [
        "Authorization": "Token \(UserDefaults().string(forKey: Constants.UserDefaults.authorizationToken) ?? "")",
        "Accept": "application/json"
    ]

    private static let hostEndpoint = "http://localhost:8000"

    /// [POST] Register new user [updated as of 7/3/20]
    static func registerUser(user: User, completion: @escaping (User) -> Void) {
        let parameters: [String: Any] = [
            "username": user.username,
            "first_name": user.firstName,
            "last_name": user.lastName,
            "social_id_token_type": user.socialIdTokenType,
            "social_id_token": user.socialIdToken,
            "profile_pic": "data:image/png;base64,\(user.profilePic)"
        ]

        AF.request("\(hostEndpoint)/api/auth/register/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userData = try? jsonDecoder.decode(Response<User>.self, from: data) {
                    completion(userData.data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Login user [updated as of 7/3/20]
    static func loginUser(username: String, socialIdToken: String, completion: @escaping (String) -> Void) {
        let parameters: [String: Any] = [
            "username": username,
            "social_id_token": socialIdToken,
        ]

        AF.request("\(hostEndpoint)/api/auth/login/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let authorizationData = try? jsonDecoder.decode(Response<Authorization>.self, from: data) {
                    let authToken = authorizationData.data.authToken
                    completion(authToken)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get a user with token [updated as of 8/11/20]
    static func getUserProfile(completion: @escaping (UserProfile) -> Void) {
        AF.request("\(hostEndpoint)/api/auth/me/", method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let userData = try? jsonDecoder.decode(Response<UserProfile>.self, from: data) {
                    let user = userData.data
                    completion(user)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Create new list for a user with default/empty settings [updated as of 8/17/20]
    static func createNewMediaList(listName: String, completion: @escaping (MediaList) -> Void) {
        let parameters: [String: Any] = [
            "name": listName,
            "is_favorite": true,
            "is_watched": true,
            "collaborators": [],
            "shows": [],
        ]

        AF.request("\(hostEndpoint)/api/lsts/", method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaListData = try? jsonDecoder.decode(Response<MediaList>.self, from: data) {
                    let mediaList = mediaListData.data
                    completion(mediaList)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get all lists of a user [updated as of 8/17/20]
    static func getAllMediaLists(completion: @escaping ([SimpleMediaList]) -> Void) {
        AF.request("\(hostEndpoint)/api/lsts/", method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaListsData = try? jsonDecoder.decode(Response<[SimpleMediaList]>.self, from: data) {
                    let mediaLists = mediaListsData.data
                    completion(mediaLists)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get list of a user by id [updated as of 8/17/20]
    static func getMediaList(listId: Int, completion: @escaping (MediaList) -> Void) {
        AF.request("\(hostEndpoint)/api/lsts/\(listId)/", method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaListData = try? jsonDecoder.decode(Response<MediaList>.self, from: data) {
                    let mediaList = mediaListData.data
                    completion(mediaList)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Update list of a user by id [updated as of 8/5/20]
    static func updateMediaList(listId: Int, list: MediaList, completion: @escaping (MediaList) -> Void) {
        let parameters: [String: Any] = [
            "name": list.name,
            "collaborators": list.collaborators.map { $0.id },
            "owner": list.owner.id,
            "is_private": list.isPrivate
        ]

        AF.request("\(hostEndpoint)/api/lsts/\(listId)/", method: .post, parameters: parameters, encoding: JSONEncoding.default , headers: headers).validate().responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaListData = try? jsonDecoder.decode(Response<MediaList>.self, from: data) {
                    let mediaList = mediaListData.data
                    completion(mediaList)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Add to list of a user by id [updated as of 8/17/20]
    static func addToMediaList(listId: Int,
                               collaboratorIds: [Int] = [],
                               mediaIds: [Int] = [],
                               tagIds: [Int] = [],
                               completion: @escaping (MediaList) -> Void) {
        let parameters: [String: Any] = [
            "collaborators": collaboratorIds,
            "shows": mediaIds,
            "tags": tagIds,
        ]
        AF.request("\(hostEndpoint)/api/lsts/\(listId)/add/", method: .post, parameters: parameters, encoding: JSONEncoding.default , headers: headers).validate().responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaListData = try? jsonDecoder.decode(Response<MediaList>.self, from: data) {
                    let mediaList = mediaListData.data
                    completion(mediaList)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Remove part of a list of a user by id [updated as of 8/17/20]
    static func removeFromMediaList(listId: Int,
                                    collaboratorIds: [Int] = [],
                                    mediaIds: [Int] = [],
                                    tagIds: [Int] = [],
                                    completion: @escaping (MediaList) -> Void) {
        let parameters: [String: Any] = [
            "collaborators": collaboratorIds,
            "shows": mediaIds,
            "tags": tagIds,
        ]
        AF.request("\(hostEndpoint)/api/lsts/\(listId)/remove/", method: .post, parameters: parameters, encoding: JSONEncoding.default , headers: headers).validate().responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaListData = try? jsonDecoder.decode(Response<MediaList>.self, from: data) {
                    let mediaList = mediaListData.data
                    completion(mediaList)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [DELETE] Delete list of a user by id [updated as of 8/5/20]
    static func deleteMediaList(listId: Int, completion: @escaping (String) -> Void) {
        AF.request("\(hostEndpoint)/api/lsts/\(listId)/", method: .delete, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let listIdData = try? jsonDecoder.decode(Response<String>.self, from: data) {
                    let message = listIdData.data
                    completion(message)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get all friends of a user [updated as of 8/7/20]
    static func getFriends(completion: @escaping ([UserProfile]) -> Void) {
        AF.request("\(hostEndpoint)/api/friends/", method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let friendsData = try? jsonDecoder.decode(Response<[UserProfile]>.self, from: data) {
                    let friendsList = friendsData.data
                    completion(friendsList)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Send invites to friends by usernames
    static func sendFriendInvites(userId: String, usernames: [String], completion: @escaping ([String]) -> Void) {
        let parameters: [String: Any] = [
            "usernames": usernames
        ]

        AF.request("\(hostEndpoint)/api/user/\(userId)/friends/invite", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let friendsData = try? jsonDecoder.decode(Response<UsernamesDataResponse>.self, from: data) {
                    let friendsUsernames = friendsData.data.usernames
                    completion(friendsUsernames)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Accept invites from friends by usernames
    static func acceptFriendInvites(userId: String, usernames: [String], completion: @escaping ([String]) -> Void) {
        let parameters: [String: Any] = [
            "usernames": usernames
        ]

        AF.request("\(hostEndpoint)/api/user/\(userId)/friends/accept", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let friendsData = try? jsonDecoder.decode(Response<UsernamesDataResponse>.self, from: data) {
                    // TODO: Double check array field key in API
                    let friendsUsernames = friendsData.data.usernames
                    completion(friendsUsernames)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Send invites to friends by usernames
    static func cancelFriendInvites(userId: String, usernames: [String], completion: @escaping ([String]) -> Void) {
        let parameters: [String: Any] = [
            "usernames": usernames
        ]

        AF.request("\(hostEndpoint)/api/user/\(userId)/friends/cancel", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let friendsData = try? jsonDecoder.decode(Response<UsernamesDataResponse>.self, from: data) {
                    let friendsUsernames = friendsData.data.usernames
                    completion(friendsUsernames)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get media information by id [updated as of 8/15/20]
    static func getMedia(mediaId: String, completion: @escaping (Media) -> Void) {
        AF.request("\(hostEndpoint)/api/show/\(mediaId)/", method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
//            print(headers)
//            print("\(hostEndpoint)/api/show/\(mediaId)/")
//            print(response)
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                print(data)
//                if let string = String(bytes: data, encoding: .utf8) {
//                    print(string)
//                }
                if let mediaData = try? jsonDecoder.decode(Response<Media>.self, from: data) {
                    let media = mediaData.data
                    print(media)
                    completion(media)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Post comment on media by id [updated as of 8/20/20]
    static func postComment(mediaId: Int, comment: String, isSpoiler: Bool, completion: @escaping (Media) -> Void) {
        print(mediaId)
        print(comment)
        print("\(hostEndpoint)/api/show/\(String(mediaId))/")
        let parameters: [String: Any] = [
            "comment": [
                "message": comment,
                "is_spoiler": isSpoiler
            ]
        ]
        print(parameters)
        AF.request("\(hostEndpoint)/api/show/\(String(mediaId))/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                print(data)
                if let string = String(bytes: data, encoding: .utf8) {
//                    print(string)
                }
                if let mediaData = try? jsonDecoder.decode(Response<Media>.self, from: data) {
                    let media = mediaData.data
//                    print(media)
                    completion(media)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

