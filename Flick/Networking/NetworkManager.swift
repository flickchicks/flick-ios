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
    private static let searchBaseUrl = "\(hostEndpoint)/api/search/"
    private static let discoverBaseUrl = "\(hostEndpoint)/api/discover/show/"

    private static func getUrlWithQuery(baseUrl: String, items: [String: String]) -> String? {
        guard let baseUrl = URL(string: baseUrl) else { return nil }
        var urlComp = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)

        var queryItems: [URLQueryItem] = []
        items.forEach { (key, value) in
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComp?.queryItems = queryItems

        return urlComp?.url?.absoluteString
    }

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
        AF.request("\(hostEndpoint)/api/me/", method: .get, headers: headers).validate().responseData { response in
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

    /// [POST] Update user profile [updated as of 8/20/20]
    static func updateUserProfile(user: User, completion: @escaping (UserProfile) -> Void) {
        let parameters: [String: Any] = [
            "username": user.username,
            "first_name": user.firstName,
            "last_name": user.lastName,
            "bio": user.bio!,
            "profile_pic": user.profilePic!,
            "phone_number": user.phoneNumber!,
            "social_id_token_type": user.socialIdTokenType,
            "social_id_token": user.socialIdToken!
        ]

        AF.request("\(hostEndpoint)/api/auth/me/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
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

    /// [GET] Get a user with id [updated as of 12/28/20]
    static func getUser(userId: Int, completion: @escaping (UserProfile) -> Void) {
        AF.request("\(hostEndpoint)/api/user/\(userId)", method: .get, headers: headers).validate().responseData { response in
            debugPrint(response)
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
    static func createNewMediaList(listName: String, mediaIds: [Int] = [], completion: @escaping (MediaList) -> Void) {
        let parameters: [String: Any] = [
            "name": listName,
            "is_favorite": true,
            "is_watched": true,
            "collaborators": [],
            "shows": mediaIds
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
    static func getMedia(mediaId: Int, completion: @escaping (Media) -> Void) {
        AF.request("\(hostEndpoint)/api/show/\(String(mediaId))/", method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaData = try? jsonDecoder.decode(Response<Media>.self, from: data) {
                    let media = mediaData.data
                    completion(media)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Post comment on media by id [updated as of 8/20/20]
    static func postComment(mediaId: Int, comment: String, isSpoiler: Bool, completion: @escaping (Media) -> Void) {
        let parameters: [String: Any] = [
            "comment": [
                "message": comment,
                "is_spoiler": isSpoiler
            ]
        ]
        AF.request("\(hostEndpoint)/api/show/\(String(mediaId))/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaData = try? jsonDecoder.decode(Response<Media>.self, from: data) {
                    let media = mediaData.data
                    completion(media)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Like comment by id [updated as of 8/21/20]
    static func likeComment(commentId: Int, completion: @escaping (Comment) -> Void) {
        let parameters: [String: Any] = [:]
        AF.request("\(hostEndpoint)/api/comment/\(String(commentId))/like/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let commentData = try? jsonDecoder.decode(Response<Comment>.self, from: data) {
                    let comment = commentData.data
                    completion(comment)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Like comment by id [updated as of 8/21/20]
    static func rateMedia(mediaId: Int, userRating: Int, completion: @escaping (Media) -> Void) {
        let parameters: [String: Any] = [
            "user_rating": userRating
        ]
        print("\(hostEndpoint)/api/show/\(String(mediaId))/")
        AF.request("\(hostEndpoint)/api/show/\(String(mediaId))/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaData = try? jsonDecoder.decode(Response<Media>.self, from: data) {
                    let media = mediaData.data
                    completion(media)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get media search result by query
    static func searchMedia(query: String, completion: @escaping (String?, [Media]) -> Void) {
        guard let url = getUrlWithQuery(baseUrl: searchBaseUrl, items: [
            "is_movie" : "true",
            "is_tv": "true",
            "query": query
        ]) else { return }

        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaData = try? jsonDecoder.decode(Response<[Media]>.self, from: data) {
                    let media = mediaData.data
                    let query = mediaData.query
                    completion(query, media)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get movies search result by query [updated as of 9/3/20]
    static func searchMovies(query: String, completion: @escaping ([Media]) -> Void) {
        guard let url = getUrlWithQuery(baseUrl: searchBaseUrl, items: [
            "is_movie" : "true",
            "query": query
        ]) else { return }

        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaData = try? jsonDecoder.decode(Response<[Media]>.self, from: data) {
                    let media = mediaData.data
                    completion(media)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get shows search result by query [updated as of 9/3/20]
    static func searchShows(query: String, completion: @escaping ([Media]) -> Void) {
        guard let url = getUrlWithQuery(baseUrl: searchBaseUrl, items: [
            "is_tv" : "true",
            "query": query
        ]) else { return }

        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let mediaData = try? jsonDecoder.decode(Response<[Media]>.self, from: data) {
                    let media = mediaData.data
                    completion(media)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get users search result by query [updated as of 9/3/20]
    static func searchUsers(query: String, completion: @escaping ([UserProfile]) -> Void) {
        guard let url = getUrlWithQuery(baseUrl: searchBaseUrl, items: [
            "is_user" : "true",
            "query": query
        ]) else { return }

        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let usersData = try? jsonDecoder.decode(Response<[UserProfile]>.self, from: data) {
                    let users = usersData.data
                    completion(users)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get tags search result by query [updated as of 9/3/20]
    static func searchTags(query: String, completion: @escaping ([Tag]) -> Void) {
        guard let url = getUrlWithQuery(baseUrl: searchBaseUrl, items: [
            "is_tag" : "true",
            "query": query
        ]) else { return }

        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let tagsData = try? jsonDecoder.decode(Response<[Tag]>.self, from: data) {
                    let tags = tagsData.data
                    completion(tags)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get lists search result by query [updated as of 9/3/20]
    static func searchLists(query: String, completion: @escaping ([MediaList]) -> Void) {
        guard let url = getUrlWithQuery(baseUrl: searchBaseUrl, items: [
            "is_lst" : "true",
            "query": query
        ]) else { return }

        AF.request(url, method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let listsData = try? jsonDecoder.decode(Response<[MediaList]>.self, from: data) {
                    let lists = listsData.data
                    completion(lists)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// [GET] Get lists search result by query [updated as of 9/3/20]
    static func discoverShows(completion: @escaping (DiscoverContent) -> Void) {
        AF.request("\(hostEndpoint)/api/discover/", method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let showsData = try? jsonDecoder.decode(Response<DiscoverContent>.self, from: data) {
                    let shows = showsData.data
                    completion(shows)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [Get] Get all suggestions [updated as of 12/30/20]
    static func getSuggestions(completion: @escaping ([Suggestion]) -> Void) {
        AF.request("\(hostEndpoint)/api/suggest/", method: .get, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let suggestionsData = try? jsonDecoder.decode(Response<[Suggestion]>.self, from: data) {
                    let suggestions = suggestionsData.data
                    completion(suggestions)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Flick a show to friend [updated as of 12/29/20]
    static func flickMediaToFriend(friendId: Int, mediaId: Int, message: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "users": [friendId],
            "show_id": mediaId,
            "message": message
        ]

        AF.request("\(hostEndpoint)/api/suggest/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    /// [POST] Create a friend request [updated as of 1/1/21]
    static func createFriendRequest(friendId: Int, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "ids": [friendId],
        ]

        AF.request("\(hostEndpoint)/api/friends/request/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    /// [POST] Accept a friend request [updated as of 1/1/21]
    static func acceptFriendRequest(friendId: Int, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "ids": [friendId],
        ]

        AF.request("\(hostEndpoint)/api/friends/accept/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    /// [POST] Reject a friend request [updated as of 1/1/21]
    static func rejectFriendRequest(friendId: Int, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "ids": [friendId],
        ]

        AF.request("\(hostEndpoint)/api/friends/reject/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
}

