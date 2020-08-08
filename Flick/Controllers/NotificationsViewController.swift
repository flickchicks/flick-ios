//
//  NotificationsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    private let notificationsTableView = UITableView(frame: .zero)
    private let notifications: [Notification] = [
//        .FriendRequest(fromUser: "Lucy Xu", type: .received),
        .FriendRequest(fromUser: "Cindy Huang", type: .sent),
        .CollaborationInvite(fromUser: "Lucy Xu", media: "Crash Landing On You"),
        .ActivityLike(fromUser: "Alanna Zou", likedContent: .comment, media: "Falling For You"),
        .ActivityLike(fromUser: "Alanna Zou", likedContent: .suggestion, media: "Love from Another Star"),
        .ListActivity(fromUser: "Haiying Weng", list: "Love Movies"),
        .FriendRequest(fromUser: "Lucy Xu", type: .received),
//        .FriendRequest(fromUser: "Cindy Huang", type: .sent),
        .CollaborationInvite(fromUser: "Lucy Xu", media: "Crash Landing On You"),
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
        notificationsTableView.separatorStyle = .none
        notificationsTableView.rowHeight = UITableView.automaticDimension
        notificationsTableView.estimatedRowHeight = 140
        notificationsTableView.sizeToFit()
        view.addSubview(notificationsTableView)

        notificationsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: notificationCellReuseIdentifier, for: indexPath) as? NotificationTableViewCell else { return UITableViewCell() }
        cell.configure(with: notifications[indexPath.row])
        return cell
    }


}
