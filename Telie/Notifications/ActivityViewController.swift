//
//  ActivityViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import NotificationBannerSwift
import NVActivityIndicatorView
import UIKit

class ActivityViewController: UIViewController {

    // MARK: - Private View Vars
    private let activityTableView = UITableView(frame: .zero, style: .grouped)
    private let emptyStateView = EmptyStateView(type: .activity)
    private let refreshControl = UIRefreshControl()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 30, height: 30),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )

    // MARK: - Private Data Vars
    private var friendRequests: [NotificationEnum] = []
    private var activities: [NotificationEnum] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .offWhite
        
        refreshControl.addTarget(self, action: #selector(refreshActivityData), for: .valueChanged)
        refreshControl.tintColor = .gradientPurple
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        activityTableView.isHidden = true
        activityTableView.delegate = self
        activityTableView.dataSource = self
        activityTableView.showsVerticalScrollIndicator = false
        activityTableView.isScrollEnabled = true
        activityTableView.backgroundColor = .offWhite
        activityTableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.reuseIdentifier)
        activityTableView.register(FriendRequestTableViewCell.self, forCellReuseIdentifier: FriendRequestTableViewCell.reuseIdentifier)
        activityTableView.separatorStyle = .none
        activityTableView.rowHeight = UITableView.automaticDimension
        activityTableView.estimatedRowHeight = 80
        activityTableView.sizeToFit()

        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            activityTableView.refreshControl = refreshControl
        } else {
            activityTableView.addSubview(refreshControl)
        }

        view.addSubview(activityTableView)
        
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)

        view.addSubview(spinner)
        spinner.startAnimating()
    
        setupConstraints()
    }
    
    private func setupConstraints() {
        activityTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }

        emptyStateView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func refreshActivityData() {
        getActivity()
    }
    
    private func getFriendRequests() {
        NetworkManager.getFriendRequests { [weak self] friendRequests in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.friendRequests = friendRequests.map {
                    return .IncomingFriendRequest(fromUser: $0.fromUser, createdAt: $0.created)
                }
                let hasActivity = self.friendRequests.count > 0 || self.activities.count > 0
                self.emptyStateView.isHidden = hasActivity
                self.activityTableView.isHidden = !hasActivity
                self.activityTableView.reloadData()
                self.updateNotificationViewedTime()
                self.refreshControl.endRefreshing()
                self.spinner.stopAnimating()
            }
        }
    }

    private func refreshFriendRequests(banner: StatusBarNotificationBanner) {
        NetworkManager.getFriendRequests { [weak self] friendRequests in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.friendRequests = friendRequests.map {
                    return .IncomingFriendRequest(fromUser: $0.fromUser, createdAt: $0.created)
                }
                print(friendRequests)
                let hasActivity = self.friendRequests.count > 0 || self.activities.count > 0
                self.emptyStateView.isHidden = hasActivity
                self.activityTableView.isHidden = !hasActivity
                self.activityTableView.reloadData()
                self.updateNotificationViewedTime()
                banner.show()

            }
        }
    }
    
    private func getActivity() {
        NetworkManager.getNotifications { [weak self] notifs in
            guard let self = self else { return }
            let notifications = self.filterNotifications(notifications: notifs)
            DispatchQueue.main.async {
                self.mapNotifications(notifications: notifications)
                self.getFriendRequests()
            }
        }
    }

    private func refreshActivity(banner: StatusBarNotificationBanner) {
        NetworkManager.getNotifications { [weak self] notifs in
            guard let self = self else { return }
            let notifications = self.filterNotifications(notifications: notifs)
            DispatchQueue.main.async {
                self.mapNotifications(notifications: notifications)
                self.refreshFriendRequests(banner: banner)
            }
        }
    }

    private func filterNotifications(notifications: [Notification]) -> [Notification] {
        // Only display supported notifications
        let notifTypes = [
            "list_invite",
            "incoming_friend_request_accepted",
            "outgoing_friend_request_accepted",
            "list_edit",
            "group_invite",
            "suggestion_like"
        ]
        return notifications.filter { notifTypes.contains($0.notifType) }
    }

    private func mapNotifications(notifications: [Notification]) {
        /* Note: Every element in returned notifications needs to be mapped to a corresponding object in our notifications array so depending on mistakes on the backend or frontend, there might be some inconsistencies in mapping the objects. I also make assumptions on the presence of values for optionals depending on the notification type, which may cause issues. For the most part this shouldn't be an issue. We can also revisit this later if need be.
        */
        self.activities = notifications.map {
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
            } else if $0.notifType == "group_invite" {
                return .GroupInvite(fromUser: $0.fromUser, group: $0.group, createdAt: $0.createdAt)
            } else {
                return .ActivityLike(fromUser: $0.fromUser, likedContent: .suggestion, media: $0.suggestion?.show.title ?? "", createdAt: $0.createdAt)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getActivity()
    }

    private func updateNotificationViewedTime() {
        let currentTime = Date().iso8601withFractionalSeconds
        NetworkManager.updateNotificationViewedTime(currentTime: currentTime) { _ in }
    }

}

extension ActivityViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return friendRequests.count > 0 ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count > 0 && section == 0 ? friendRequests.count : activities.count
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
            switch activities[indexPath.row] {
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
            case .GroupInvite(_, let group, _):
                guard let group = group else { return }
                navigationController?.pushViewController(GroupViewController(group: group), animated: true)
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
        headerLabel.text = section == 0 && friendRequests.count > 0 ? "Friend Requests" : "Activity"
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
            cell.configure(with: activities[indexPath.row])
            cell.notificationDelegate = self
            return cell
        }
    }
}

extension ActivityViewController: ActivityDelegate {
    func refreshActivity(message: String) {
        let banner = StatusBarNotificationBanner(
            title: message,
            style: .info,
            colors: CustomBannerColors()
        )
        refreshActivity(banner: banner)
    }
}

extension ActivityViewController: NotificationDelegate {

    func pushProfileViewController(id: Int) {
        navigationController?.pushViewController(ProfileViewController(isHome: false, userId: id), animated: true)
    }

}
