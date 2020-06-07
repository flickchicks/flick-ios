////
////  NetworkManager.swift
////  Flick
////
////  Created by Lucy Xu on 5/25/20.
////  Copyright © 2020 flick. All rights reserved.
////
//
//import Foundation
//import Alamofire
//
//class NetworkManager {
//
//    static let shared: NetworkManager = NetworkManager()
//
//    // TODO: Replace endpoints
//    private static let hostEndpoint = "http://localhost:3000"
//
//    /// [POST] Create new or update existing user
//    static func createUser(user: User, completion: @escaping (String) -> Void) {
//        let parameters: [String: Any] = [
//            "username": user.username,
//            "id": user.id,
//            "name": user.name,
//            "facebook_id": user.facebookId,
//            "profile_pic": user.profilePic
//        ]
//
//        Alamofire.request("\(hostEndpoint)/api/user", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                if let userIdData = try? jsonDecoder.decode(Response<IdResponse>.self, from: data) {
//                    let userId = userIdData.data.id
//                    completion(userId)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [GET] Get a user by id
//    static func getUser(userId: String, completion: @escaping (User) -> Void) {
//        // TODO: Check if we want to use GET parameters
//        Alamofire.request("\(hostEndpoint)/api/user/\(userId)", method: .get).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                if let userData = try? jsonDecoder.decode(Response<User>.self, from: data) {
//                    let user = userData.data
//                    completion(user)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [POST] Create new list for a user
//    static func createMediaList(userId: String, list: MediaListBody, completion: @escaping (String) -> Void) {
//        let parameters: [String: Any] = [
//            "movie_ids": list.movieIds,
//            "collaborators": list.collaborators,
//            "is_private": list.isPrivate,
//            "timestamp": list.timestamp,
//            "list_name": list.listName
//        ]
//
//        Alamofire.request("\(hostEndpoint)/api/user/\(userId)/list", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                if let listIdData = try? jsonDecoder.decode(Response<IdResponse>.self, from: data) {
//                    let listId = listIdData.data.id
//                    completion(listId)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [GET] Get all lists of a user
//    static func getAllMediaLists(userId: String, completion: @escaping ([MediaList]) -> Void) {
//        Alamofire.request("\(hostEndpoint)/api/user/\(userId)/lists", method: .get, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                if let mediaListsData = try? jsonDecoder.decode(Response<MediaListsResponse>.self, from: data) {
//                    let mediaLists = mediaListsData.data.lists
//                    completion(mediaLists)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [GET] Get list of a user by id
//    static func getMediaList(userId: String, listId: String, completion: @escaping (MediaList) -> Void) {
//        Alamofire.request("\(hostEndpoint)/api/user/\(userId)/list/\(listId)", method: .get, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                if let mediaListData = try? jsonDecoder.decode(Response<MediaList>.self, from: data) {
//                    let mediaList = mediaListData.data
//                    completion(mediaList)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [POST] Update list of a user by id
//    static func updateMediaList(userId: String, listId: String, list: MediaListBody, completion: @escaping (MediaList) -> Void) {
//        // TODO: Revisit parameters. Current implementation omits delete_media_ids and add_media_ids
//        let parameters: [String: Any] = [
//            "movie_ids": list.movieIds,
//            "collaborators": list.collaborators,
//            "is_private": list.isPrivate,
//            "tags": list.tags,
//            "list_name": list.listName,
//            "list_pic": list.listPic
//        ]
//
//        Alamofire.request("\(hostEndpoint)/api/user/\(userId)/list/\(listId)", method: .get, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                if let mediaListData = try? jsonDecoder.decode(Response<MediaList>.self, from: data) {
//                    let mediaList = mediaListData.data
//                    completion(mediaList)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [DELETE] Delete list of a user by id
//    static func getMediaList(userId: String, listId: String, completion: @escaping (String) -> Void) {
//        Alamofire.request("\(hostEndpoint)/api/user/\(userId)/list/\(listId)", method: .delete, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                if let listIdData = try? jsonDecoder.decode(Response<IdResponse>.self, from: data) {
//                    let listId = listIdData.data.id
//                    completion(listId)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [POST] Send invites to friends by usernames
//    static func sendFriendInvites(userId: String, usernames: [String], completion: @escaping ([String]) -> Void) {
//        let parameters: [String: Any] = [
//            "usernames": usernames
//        ]
//
//        Alamofire.request("\(hostEndpoint)/api/user/\(userId)/friends/invite", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                if let friendsData = try? jsonDecoder.decode(Response<UsernamesDataResponse>.self, from: data) {
//                    let friendsUsernames = friendsData.data.usernames
//                    completion(friendsUsernames)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [POST] Accept invites from friends by usernames
//    static func acceptFriendInvites(userId: String, usernames: [String], completion: @escaping ([String]) -> Void) {
//        let parameters: [String: Any] = [
//            "usernames": usernames
//        ]
//
//        Alamofire.request("\(hostEndpoint)/api/user/\(userId)/friends/accept", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                if let friendsData = try? jsonDecoder.decode(Response<UsernamesDataResponse>.self, from: data) {
//                    // TODO: Double check array field key in API
//                    let friendsUsernames = friendsData.data.usernames
//                    completion(friendsUsernames)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [POST] Send invites to friends by usernames
//    static func cancelFriendInvites(userId: String, usernames: [String], completion: @escaping ([String]) -> Void) {
//        let parameters: [String: Any] = [
//            "usernames": usernames
//        ]
//
//        Alamofire.request("\(hostEndpoint)/api/user/\(userId)/friends/cancel", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                if let friendsData = try? jsonDecoder.decode(Response<UsernamesDataResponse>.self, from: data) {
//                    let friendsUsernames = friendsData.data.usernames
//                    completion(friendsUsernames)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [GET] Get all friends of a user
//    static func getFriends(userId: String, completion: @escaping ([User]) -> Void) {
//        Alamofire.request("\(hostEndpoint)/api/user/\(userId)/friends)", method: .get, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                if let friendsData = try? jsonDecoder.decode(Response<FriendsDataResponse>.self, from: data) {
//                    let friendsList = friendsData.data.friends
//                    completion(friendsList)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    /// [POST] Get media information by id
//    static func getMedia(mediaId: String, completion: @escaping (Media) -> Void) {
//        let parameters: [String: Any] = [
//            "media_id": mediaId
//        ]
//
//        Alamofire.request("\(hostEndpoint)/api/media", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
//                if let mediaData = try? jsonDecoder.decode(Response<Media>.self, from: data) {
//                    let media = mediaData.data
//                    completion(media)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//}

