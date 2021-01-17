//
//  NotificationsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SkeletonView

class NotificationsViewController: UIViewController {

    // MARK: - Private View Vars
    private let notificationsTableView = UITableView(frame: .zero, style: .grouped)

    // MARK: - Private Data Vars
    private var friendRequests: [NotificationEnum] = []
    private var notifications: [NotificationEnum] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .offWhite
        view.isSkeletonable = true
        
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.isScrollEnabled = true
        notificationsTableView.isSkeletonable = true
        notificationsTableView.backgroundColor = .offWhite
        notificationsTableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.reuseIdentifier)
        notificationsTableView.register(FriendRequestTableViewCell.self, forCellReuseIdentifier: FriendRequestTableViewCell.reuseIdentifier)
        notificationsTableView.separatorStyle = .none
        notificationsTableView.rowHeight = UITableView.automaticDimension
        notificationsTableView.estimatedRowHeight = 80
        notificationsTableView.sizeToFit()
        view.addSubview(notificationsTableView)
        
        notificationsTableView.showAnimatedSkeleton(usingColor: .lightPurple, animation: .none, transition: .crossDissolve(0.25))

        notificationsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func getFriendRequests() {
        NetworkManager.getFriendRequests { [weak self] friendRequests in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.friendRequests = friendRequests.map {
                    return .IncomingFriendRequest(fromUser: $0.fromUser, createdAt: $0.created)
                }
                self.notificationsTableView.reloadData()
                self.updateNotificationViewedTime()
            }
        }
    }
    
    private func getNotifications() {
        NetworkManager.getNotifications { [weak self] notifications in
            guard let self = self else { return }
            DispatchQueue.main.async {
                /* Note: Every element in returned notifications needs to be mapped to a corresponding object in our notifications array so depending on mistakes on the backend or frontend, there might be some inconsistencies in mapping the objects. I also make assumptions on the presence of values for optionals depending on the notification type, which may cause issues. For the most part this shouldn't be an issue. We can also revisit this later if need be.
                */
                self.notifications = notifications.map {
                    if $0.notifType == "list_invite" {
                        return .CollaborationInvite(fromUser: $0.fromUser, list: $0.lst!, createdAt: $0.createdAt)
                    } else if $0.notifType == "incoming_friend_request_accepted" {
                        return .AcceptedIncomingFriendRequest(fromUser: $0.fromUser, createdAt: $0.createdAt)
                    } else if $0.notifType == "outgoing_friend_request_accepted" {
                        return .AcceptedOutgoingFriendRequest(fromUser: $0.fromUser, createdAt: $0.createdAt)
                    } else if $0.notifType == "list_edit" {
                        if let numShowsAdded = $0.numShowsAdded, let list = $0.lst {
                            return .ListShowsEdit(fromUser: $0.fromUser, list: list, type: .added, numChanged: numShowsAdded, createdAt: $0.createdAt)
                        } else if let numShowsRemoved = $0.numShowsRemoved, let list = $0.lst  {
                            return .ListShowsEdit(fromUser: $0.fromUser, list: list, type: .removed, numChanged: numShowsRemoved, createdAt: $0.createdAt)
                        } else if let newOwner = $0.newOwner, let list = $0.lst {
                            return .ListOwnershipEdit(fromUser: $0.fromUser, list: list, newOwner: newOwner, createdAt: $0.createdAt)
                        } else if let list = $0.lst, $0.collaboratorsAdded.count > 0 {
                            return .ListCollaboratorsEdit(fromUser: $0.fromUser, list: list, type: .added, collaborators: $0.collaboratorsAdded, createdAt: $0.createdAt)
                        }
                        else {
                            return .ListCollaboratorsEdit(fromUser: $0.fromUser, list: $0.lst!, type: .removed, collaborators: $0.collaboratorsRemoved, createdAt: $0.createdAt)
                        }
                    } else {
                        // TODO: Revisit after backend finishes notifications
                        return .ActivityLike(fromUser: $0.fromUser, likedContent: .suggestion, media: "Love from Another Star", createdAt: $0.createdAt)
                    }
                }
                self.getFriendRequests()
                self.notificationsTableView.hideSkeleton()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getNotifications()
    }

    private func updateNotificationViewedTime() {
        let currentTime = Date().iso8601withFractionalSeconds
        NetworkManager.updateNotificationViewedTime(currentTime: currentTime) { success in
            if success {
                print("Updated notification viewed time")
            } else {
                print("Failed to update notification viewed time")
            }
        }
    }

}

extension NotificationsViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return NotificationTableViewCell.reuseIdentifier
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return friendRequests.count > 0 ? 2 : 1
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count > 0 && section == 0 ? friendRequests.count : notifications.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if friendRequests.count > 0 && indexPath.section == 0 {
            // Incoming friend request
            switch friendRequests[indexPath.row] {
            case .IncomingFriendRequest(let fromUser, _):
                let profileViewController = ProfileViewController(isHome: false, userId: fromUser.id)
                navigationController?.pushViewController(profileViewController, animated: true)
            default:
                break
            }
        } else {
            switch notifications[indexPath.row] {
            case .AcceptedIncomingFriendRequest(let fromUser, _):
                navigationController?.pushViewController(ProfileViewController(isHome: false, userId: fromUser.id), animated: true)
            case .AcceptedOutgoingFriendRequest(let fromUser, _):
                navigationController?.pushViewController(ProfileViewController(isHome: false, userId: fromUser.id), animated: true)
            case .CollaborationInvite(_, let list, _):
                navigationController?.pushViewController(ListViewController(listId: list.id), animated: true)
            case .ListShowsEdit(_, let list, _, _, _):
                navigationController?.pushViewController(ListViewController(listId: list.id), animated: true)
            case .ListCollaboratorsEdit(_, let list, _, _, _):
                navigationController?.pushViewController(ListViewController(listId: list.id), animated: true)
            case .ListOwnershipEdit(_, let list, _, _):
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
        headerLabel.text = section == 0 && friendRequests.count > 0 ? "Friend Requests" : "Notifications"
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendRequestTableViewCell.reuseIdentifier, for: indexPath) as? FriendRequestTableViewCell else { return UITableViewCell() }
            cell.configure(with: friendRequests[indexPath.row])
            cell.delegate = self
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuseIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
            cell.configure(with: notifications[indexPath.row])
            return cell
        }
    }
}

extension NotificationsViewController: NotificationDelegate {
    func refreshNotifications(message: String) {
        presentInfoAlert(message: message, completion: nil)
        getNotifications()
    }
}
