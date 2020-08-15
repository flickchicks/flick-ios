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
    private let friendRequests: [Notification] = [
        .FriendRequest(fromUser: "Lucy Xu", type: .received),
        .FriendRequest(fromUser: "Lucy Xu", type: .received)
    ]
    private let friendRequestCellReuseIdentifier = "FriendRequestCellReuseIdentifier"
    private let notifications: [Notification] = [
        .CollaborationInvite(fromUser: "Lucy Xu", media: "Crash Landing On You"),
        .FriendRequest(fromUser: "Haiying Weng", type: .sent),
        .ActivityLike(fromUser: "Alanna Zou", likedContent: .comment, media: "Falling For You"),
        .ActivityLike(fromUser: "Alanna Zou", likedContent: .suggestion, media: "Love from Another Star"),
        .ListActivity(fromUser: "Haiying Weng", list: "Love Movies"),
        .CollaborationInvite(fromUser: "Lucy Xu", media: "Crash Landing On You"),
        .FriendRequest(fromUser: "Alanna Zhou", type: .sent),
        .ActivityLike(fromUser: "Alanna Zou", likedContent: .comment, media: "Falling For You"),
        .ActivityLike(fromUser: "Alanna Zou", likedContent: .suggestion, media: "Love from Another Star"),
        .ListActivity(fromUser: "Haiying Weng", list: "Love Movies")
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
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return friendRequests.count > 0 ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequests.count > 0 && section == 0 ? friendRequests.count : notifications.count
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
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: notificationCellReuseIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
            cell.configure(with: notifications[indexPath.row])
            return cell
        }
    }


}
