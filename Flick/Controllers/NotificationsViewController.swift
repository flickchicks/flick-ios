//
//  NotificationsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    // MARK: - Private View Vars
    private let notificationsTableView = UITableView(frame: .zero, style: .grouped)

    // MARK: - Private Data Vars
    // TODO: Replace with backend values
    private var friendRequests: [Notification] = [] // Only requests that have been sent to user
    private let friendRequestCellReuseIdentifier = "FriendRequestCellReuseIdentifier"
    private var notifications: [Notification] = [
//        .CollaborationInvite(fromUser: "Lucy Xu", media: "Crash Landing On You"),
//        .FriendRequest(fromUser: "Haiying Weng", type: .sent),
//        .ActivityLike(fromUser: "Alanna Zou", likedContent: .comment, media: "Falling For You"),
//        .ActivityLike(fromUser: "Alanna Zou", likedContent: .suggestion, media: "Love from Another Star"),
//        .ListActivity(fromUser: "Haiying Weng", list: "Love Movies"),
//        .CollaborationInvite(fromUser: "Lucy Xu", media: "Crash Landing On You"),
//        .FriendRequest(fromUser: "Alanna Zhou", type: .sent),
//        .ActivityLike(fromUser: "Alanna Zou", likedContent: .comment, media: "Falling For You"),
//        .ActivityLike(fromUser: "Alanna Zou", likedContent: .suggestion, media: "Love from Another Star"),
//        .ListActivity(fromUser: "Haiying Weng", list: "Love Movies")
    ]
    private let notificationCellReuseIdentifier = "NotificationCellReuseIdentifier"

    override func viewDidLoad() {
        view.backgroundColor = .offWhite
        
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.isScrollEnabled = true
        notificationsTableView.backgroundColor = .offWhite
        notificationsTableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: notificationCellReuseIdentifier)
        notificationsTableView.register(FriendRequestTableViewCell.self, forCellReuseIdentifier: friendRequestCellReuseIdentifier)
        notificationsTableView.separatorStyle = .none
        notificationsTableView.rowHeight = UITableView.automaticDimension
        notificationsTableView.estimatedRowHeight = 140
        notificationsTableView.sizeToFit()
        view.addSubview(notificationsTableView)

        notificationsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func getFriendRequests() {
        NetworkManager.getFriendRequests { [weak self] requests in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let requests: [Notification] = requests.map {
                    return .IncomingFriendRequest(fromUser: $0.fromUser)
                }
                self.friendRequests = requests
//                self.notificationsTableView.reloadData()
            }
        }
    }
    
    private func getAllNotifications() {
        
//        getFriendRequests()
        
        NetworkManager.getNotifications { [weak self] notifications in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let newNotifs: [Notification] = notifications.map {
                    if $0.notifType == "list_invite" {
                        return .CollaborationInvite(fromUser: $0.fromUser, list: $0.lst!)
                    } else if $0.notifType == "friend_request" {
                        return .FriendRequest(fromUser: $0.fromUser, toUser: $0.toUser)
                    } else if $0.notifType == "list_edit" {
                        // TODO: Are these notifications cumulative?
                        if let numShowsAdded = $0.numShowsAdded, let list = $0.lst {
                            return .ListShowsEdit(fromUser: $0.fromUser, list: list, type: .added, numChanged: numShowsAdded)
                        } else if let numShowsRemoved = $0.numShowsRemoved, let list = $0.lst  {
                            return .ListShowsEdit(fromUser: $0.fromUser, list: list, type: .removed, numChanged: numShowsRemoved)
                        } else if let newOwner = $0.newOwner, let list = $0.lst {
                            return .ListOwnershipEdit(fromUser: $0.fromUser, list: list, newOwner: newOwner)
                        } else if let list = $0.lst, $0.collaboratorsAdded.count > 0 {
                            return .ListCollaboratorsEdit(fromUser: $0.fromUser, list: list, type: .added, collaborators: $0.collaboratorsAdded)
                        }
                        else {
                            return .ListCollaboratorsEdit(fromUser: $0.fromUser, list: $0.lst!, type: .removed, collaborators: $0.collaboratorsRemoved)
                        }
                    } else {
                        return .ActivityLike(fromUser: $0.fromUser, likedContent: .suggestion, media: "Love from Another Star")
                    }
                }
                self.notifications = newNotifs
                self.getFriendRequests()
                self.notificationsTableView.reloadData()
            }
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getAllNotifications()
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return friendRequests.count > 0 ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count > 0 && section == 0 ? friendRequests.count : notifications.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if friendRequests.count > 0 && indexPath.section == 0 {
            // Incoming friend request
            switch friendRequests[indexPath.row] {
            case .IncomingFriendRequest(let fromUser):
                let profileViewController = ProfileViewController(userId: fromUser.id)
                navigationController?.pushViewController(profileViewController, animated: true)
            default:
                break
            }
        } else {
            switch notifications[indexPath.row] {
            case .FriendRequest(let fromUser, let toUser):
                if toUser.id == UserDefaults.standard.integer(forKey: Constants.UserDefaults.userId) {
                    // Friend request was sent to fromUser and accepted by the current user
                    navigationController?.pushViewController(ProfileViewController(userId: fromUser.id), animated: true)
                } else {
                    // Friend request was sent by the current user and accepted by toUser
                    navigationController?.pushViewController(ProfileViewController(userId: toUser.id), animated: true)
                }
            case .CollaborationInvite(_, let list):
                navigationController?.pushViewController(ListViewController(listId: list.id), animated: true)
            case .ListShowsEdit(_, let list, _, _):
                navigationController?.pushViewController(ListViewController(listId: list.id), animated: true)
            case .ListCollaboratorsEdit(_, let list, _, _):
                navigationController?.pushViewController(ListViewController(listId: list.id), animated: true)
            case .ListOwnershipEdit(_, let list, _):
                navigationController?.pushViewController(ListViewController(listId: list.id), animated: true)
            default:
                break
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let padding = 20
        let headerView = UIView()
        headerView.backgroundColor = .offWhite
        let headerLabel = UILabel()
        headerLabel.textColor = .darkBlueGray2
        headerLabel.font = .boldSystemFont(ofSize: 12)
        headerLabel.text = section == 0 && friendRequests.count > 0 ? "New Friend Requests" : "Other Notifications"
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(padding)
        }
        if friendRequests.count > 0 && section == 1 {
            let spacerView = UIView()
            spacerView.backgroundColor = .lightGray2
            headerView.addSubview(spacerView)
            spacerView.snp.makeConstraints { make in
                make.height.equalTo(2)
                make.leading.trailing.equalToSuperview().inset(padding)
                make.bottom.equalTo(headerLabel.snp.top).offset(-padding)
            }
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return friendRequests.count > 0 && section == 1 ? 43 : 31
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if friendRequests.count > 0 && indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: friendRequestCellReuseIdentifier, for: indexPath) as? FriendRequestTableViewCell else { return UITableViewCell() }
            cell.configure(with: friendRequests[indexPath.row])
            cell.delegate = self
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: notificationCellReuseIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
            cell.configure(with: notifications[indexPath.row])
            return cell
        }
    }
}

extension NotificationsViewController: NotificationDelegate {
    func refreshNotifications(message: String) {
        presentInfoAlert(message: message, completion: nil)
        getAllNotifications()
    }
}
