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

    static var headers: HTTPHeaders {
        let headers: HTTPHeaders = [
            "Authorization": "Token \(UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizationToken) ?? "")",
            "Accept": "application/json"
        ]
        return headers
    }

    #if LOCAL
    private static let hostEndpoint = "http://localhost:8000"
//    private static let hostEndpoint = "http://\(Keys.serverURL)"
    #else
    private static let hostEndpoint = "http://\(Keys.serverURL)"
    #endif
    
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

    // MARK: - Users

    /// [POST] Authenticate a user  on register and login[updated as of 1/26/21]
    static func authenticateUser(firstName: String, lastName: String, email: String?, profilePic: String, socialId: String, socialIdToken: String, socialIdTokenType: String, completion: @escaping (String) -> Void) {
        let parameters: [String: Any] = [
            "username": "",
            "name": "\(firstName) \(lastName)",
            "email": email,
            "profile_pic": profilePic,
            "social_id": socialId,
            "social_id_token": socialIdToken,
            "social_id_token_type": socialIdTokenType
        ]

        AF.request("\(hostEndpoint)/api/authenticate/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
//            debugPrint(response)
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
    static func getUserProfile(completion: @escaping (UserProfile?) -> Void) {
        
        var myProfileURLRequest = URLRequest(url: URL(string: "\(hostEndpoint)/api/me/")!)
        myProfileURLRequest.httpMethod = "GET"
        myProfileURLRequest.cachePolicy = .returnCacheDataElseLoad
        myProfileURLRequest.setValue("Token \(UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizationToken) ?? "")", forHTTPHeaderField: "Authorization")
        
        AF.request(myProfileURLRequest).validate().responseData { response in
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
                completion(nil)
            }
        }
    }

    /// [POST] Update user profile [updated as of 1/10/21]
    static func updateUserProfile(user: User, completion: @escaping (UserProfile) -> Void) {
        let parameters: [String: Any] = [
            "username": user.username,
            "name": user.name,
            "bio": user.bio,
            "profile_pic": user.profilePic,
            "phone_number": user.phoneNumber,
            "social_id_token": user.socialIdToken,
            "social_id_token_type": user.socialIdTokenType
        ]

        AF.request("\(hostEndpoint)/api/me/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
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

    /// [POST] Check if a username does not exists [updated as of 1/5/20]
    static func checkUsernameNotExists(username: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "username": username
        ]

        AF.request("\(hostEndpoint)/api/username/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            // completion true if username does not exists
            case .success:
                completion(true)
            // completion false if username already exists
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    /// [GET] Get a user with id [updated as of 12/28/20]
    static func getUser(userId: Int, completion: @escaping (UserProfile) -> Void) {
        AF.request("\(hostEndpoint)/api/user/\(userId)/", method: .get, headers: headers).validate().responseData { response in
//            debugPrint(response)
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

    // MARK: - List

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
            "owner": list.owner.id,
            "is_private": list.isPrivate
        ]

        AF.request("\(hostEndpoint)/api/lsts/\(listId)/", method: .post, parameters: parameters, encoding: JSONEncoding.default , headers: headers).validate().responseData { response in
//            debugPrint(response)
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
//            debugPrint(response)
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

    // MARK: - Friends

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

    /// [GET] Get all friends of an user by user id [updated as of 1/9/21]
    static func getFriendsOfUser(userId: Int, completion: @escaping ([UserProfile]) -> Void) {
        AF.request("\(hostEndpoint)/api/user/\(userId)/friends/", method: .get, headers: headers).validate().responseData { response in
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

    /// [GET] View friend requests [updated as of 1/8/21]
    static func getFriendRequests(completion: @escaping ([FriendRequest]) -> Void) {
        AF.request("\(hostEndpoint)/api/friends/accept/", method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let friendRequestsData = try? jsonDecoder.decode(Response<[FriendRequest]>.self, from: data) {
                    let friendRequests = friendRequestsData.data
                    completion(friendRequests)
                }
            case .failure(let error):
                print(error.localizedDescription)
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

    // MARK: - Media

    /// [GET] Get media information by id [updated as of 8/15/20]
    static func getMedia(mediaId: Int, completion: @escaping (Media) -> Void) {
        var mediaURLRequest = URLRequest(url: URL(string: "\(hostEndpoint)/api/show/\(String(mediaId))/")!)
        mediaURLRequest.httpMethod = "GET"
        mediaURLRequest.cachePolicy = .returnCacheDataElseLoad
        mediaURLRequest.setValue("Token \(UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizationToken) ?? "")", forHTTPHeaderField: "Authorization")
        
        AF.request(mediaURLRequest).validate().responseData { response in
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
        AF.request("\(hostEndpoint)/api/comment/\(commentId)/like/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            debugPrint(response)
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

    // MARK: - Search

    /// [GET] Get media search result by query [updated as of 1/16/21]
    static func searchMedia(query: String, completion: @escaping (String?, [Media]) -> Void) {
        guard let url = getUrlWithQuery(baseUrl: searchBaseUrl, items: [
            "is_multi" : "true",
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

    // MARK: - Discover
    
    /// [GET] Get lists search result by query [updated as of 9/3/20]
    static func discoverShows(completion: @escaping (DiscoverContent) -> Void) {
        var discoverShowURLRequest = URLRequest(url: URL(string:"\(hostEndpoint)/api/discover/")!)
        discoverShowURLRequest.httpMethod = "GET"
        discoverShowURLRequest.cachePolicy = .returnCacheDataElseLoad
        
        AF.request(discoverShowURLRequest).validate().responseData { response in
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

    // MARK: - Notifications

    /// [GET] Get all notifications
    static func getNotifications(completion: @escaping ([Notification]) -> Void) {
        
        var notificationsURLRequest = URLRequest(url: URL(string: "\(hostEndpoint)/api/notifications/")!)
        notificationsURLRequest.httpMethod = "GET"
        notificationsURLRequest.cachePolicy = .returnCacheDataElseLoad
        notificationsURLRequest.setValue("Token \(UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizationToken) ?? "")", forHTTPHeaderField: "Authorization")
        
        AF.request(notificationsURLRequest).validate().responseData { response in
            switch response.result {
            case .success(let data):
                debugPrint(data)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let notificationsData = try? jsonDecoder.decode(Response<[Notification]>.self, from: data) {
                    let notifications = notificationsData.data
                    completion(notifications)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }

    /// [POST] Update notification viewed time [updated as of 1/15/21]
    static func updateNotificationViewedTime(currentTime: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "notif_time_viewed": currentTime
        ]

        AF.request("\(hostEndpoint)/api/notifications/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    // MARK: - Suggestions
    
    /// [GET] Get all suggestions [updated as of 12/30/20]
    static func getSuggestions(completion: @escaping ([Suggestion]) -> Void) {
        
        var suggestionsURLRequest = URLRequest(url: URL(string: "\(hostEndpoint)/api/suggestions/")!)
        suggestionsURLRequest.httpMethod = "GET"
        suggestionsURLRequest.cachePolicy = .returnCacheDataElseLoad
        suggestionsURLRequest.setValue("Token \(UserDefaults.standard.string(forKey: Constants.UserDefaults.authorizationToken) ?? "")", forHTTPHeaderField: "Authorization")
        
        AF.request(suggestionsURLRequest).validate().responseData { response in
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

    /// [POST] Update suggestion viewed time [updated as of 1/15/21]
    static func updateSuggestionViewedTime(currentTime: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "suggest_time_viewed": currentTime
        ]

        AF.request("\(hostEndpoint)/api/suggestions/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    /// [POST] Flick a show to friends [updated as of 12/29/20]
    static func flickMediaToFriends(friendIds: [Int], mediaId: Int, message: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "users": friendIds,
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

    // MARK: - Push Notifications

    /// [POST] Enable push notifications by sending device token [updated as of 1/23/21]
    static func enableNotifications(deviceToken: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = [
            "device_type": "ios",
            "device_token": deviceToken
        ]

        AF.request("\(hostEndpoint)/api/notifications/enable/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    // MARK: - Group

    /// [GET] Get groups [updated 1/29/21]
    static func getGroups(completion: @escaping ([Group]) -> Void) {
        AF.request("\(hostEndpoint)/api/groups/", method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let groupsData = try? jsonDecoder.decode(Response<[Group]>.self, from: data) {
                    let groups = groupsData.data
                    completion(groups)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Create a group [updated as of 1/29/21]
    static func createGroup(name: String, completion: @escaping (Group) -> Void) {
        let parameters: [String: Any] = [
            "name": name,
            "members": []
        ]

        AF.request("\(hostEndpoint)/api/groups/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let groupData = try? jsonDecoder.decode(Response<Group>.self, from: data) {
                    let group = groupData.data
                    completion(group)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [GET] Get a group by id [updated 1/29/21]
    static func getGroup(id: Int, completion: @escaping (Group) -> Void) {
        AF.request("\(hostEndpoint)/api/groups/\(id)/", method: .get, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let groupData = try? jsonDecoder.decode(Response<Group>.self, from: data) {
                    let group = groupData.data
                    completion(group)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Update group detail [updated as of 1/29/21]
    static func updateGroup(id: Int, name: String, completion: @escaping (Group) -> Void) {
        let parameters: [String: Any] = [
            "name": name
        ]

        AF.request("\(hostEndpoint)/api/groups/\(id)/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let groupData = try? jsonDecoder.decode(Response<Group>.self, from: data) {
                    let group = groupData.data
                    completion(group)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Add  to group [updated as of 1/29/21]
    static func addToGroup(id: Int, memberIds: [Int] = [], mediaIds: [Int] = [], completion: @escaping (Group) -> Void) {
        let parameters: [String: Any] = [
            "members": memberIds,
            "shows": mediaIds
        ]

        AF.request("\(hostEndpoint)/api/groups/\(id)/add/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let groupData = try? jsonDecoder.decode(Response<Group>.self, from: data) {
                    let group = groupData.data
                    completion(group)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// [POST] Remove froms group [updated as of 1/29/21]
    static func removeFromGroup(id: Int, memberIds: [Int] = [], showIds: [Int] = [], completion: @escaping (Group) -> Void) {
        let parameters: [String: Any] = [
            "members": memberIds,
            "shows": showIds
        ]

        AF.request("\(hostEndpoint)/api/groups/\(id)/remove/", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let groupData = try? jsonDecoder.decode(Response<Group>.self, from: data) {
                    let group = groupData.data
                    completion(group)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

