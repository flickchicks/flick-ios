//
//  ProfileViewController.swift
//  Flick
//
//  Created by Lucy Xu on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum FriendsLayoutMode { case expanded, condensed }

class ProfileViewController: UIViewController {

    // MARK: - Private View Vars
    private let addListButton = UIButton()
    private var friendsPreviewView: UsersPreviewView!
    private let listsContainerView = RoundTopView(hasShadow: true)
    private var listsTableView: UITableView!
    private let nameLabel = UILabel()
    private let notificationButton = UIButton()
    private let profileImageView = UIImageView()
    private let settingsButton = UIButton()
    private let userInfoView = UIView()
    private let usernameLabel = UILabel()

    // MARK: - Private Data Vars
    private let addListButtonSize = CGSize(width: 72, height: 72)
    private var condensedCellSpacing = -8
    private var expandedCellSpacing = -5
    private let listCellReuseIdentifier = "ListCellReuseIdentifier"
    private let profileImageSize = CGSize(width: 70, height: 70)
    private let sideButtonsSize = CGSize(width: 24, height: 24)

    // TODO: Update with backend values
    private let name = "Alanna Zhou"
    private let username = "alannaz"
    private let friends = ["A", "B", "C", "D", "E", "F", "G"]

    private let media = Media(
        mediaId: "123",
        title: "Title",
        tags: ["tag"],
        posterPic: "null",
        director: "Director",
        isTV: false,
        dateReleased: "1/1/2020",
        status: "status",
        language: "language",
        duration: "duration",
        plot: "plot",
        keywords: ["keyword"],
        seasons: "4",
        audienceLevel: "audience",
        imbdRating: "4",
        friendsRating: "4",
        tomatoRating: "4",
        platforms: ["Netflix"]
    )
    private var mediaLists: [MediaList] = [
        MediaList(
            listId: "id",
            collaborators: ["A", "B", "C"],
            isPrivate: false,
            isFavorite: false,
            timestamp: "time",
            listName: "Saved",
            listPic: "null",
            tags: ["tag"],
            media: []
        ),
        MediaList(
            listId: "id",
            collaborators: [],
            isPrivate: true,
            isFavorite: false,
            timestamp: "time",
            listName: "Watchlist",
            listPic: "null",
            tags: ["tag"],
            media: []
        ),
        MediaList(
            listId: "id",
            collaborators: ["A", "B", "C", "D"],
            isPrivate: false,
            isFavorite: false,
            timestamp: "time",
            listName: "K Drama",
            listPic: "null",
            tags: ["tag"],
            media: []
        )
    ]

    override func viewDidLoad() {
        // TODO: Update with backend values
        mediaLists[0].media = [media,media,media,media,media,media,media,media]
        mediaLists[1].media = [media,media,media]
        mediaLists[2].media = [media,media,media,media,media,media,media,media]

        super.viewDidLoad()
        view.backgroundColor = .offWhite

        profileImageView.backgroundColor = .deepPurple
        profileImageView.layer.cornerRadius = profileImageSize.width / 2
        view.addSubview(profileImageView)

        nameLabel.text = name
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = .darkBlue
        view.addSubview(nameLabel)

        usernameLabel.text = "@\(username)"
        usernameLabel.font = .systemFont(ofSize: 12)
        usernameLabel.textColor = .mediumGray
        usernameLabel.sizeToFit()
        userInfoView.addSubview(usernameLabel)

        friendsPreviewView = UsersPreviewView(users: friends, usersLayoutMode: .friends)
        userInfoView.addSubview(friendsPreviewView)

        view.addSubview(userInfoView)

        notificationButton.setImage(UIImage(named: "notificationButton"), for: .normal)
        view.addSubview(notificationButton)

        settingsButton.setImage(UIImage(named: "settingsButton"), for: .normal)
        view.addSubview(settingsButton)

        listsTableView = UITableView(frame: .zero, style: .plain)
        listsTableView.dataSource = self
        listsTableView.delegate = self
        listsTableView.register(ListTableViewCell.self, forCellReuseIdentifier: listCellReuseIdentifier)
        listsTableView.separatorStyle = .none
        listsContainerView.addSubview(listsTableView)
        view.addSubview(listsContainerView)

        // TODO: Replace button image
        addListButton.setImage(UIImage(named: "newList"), for: .normal)
        addListButton.layer.cornerRadius = addListButtonSize.width / 2
        view.addSubview(addListButton)

        setupConstraints()
    }

    private func setupConstraints() {

        // Calculate width of friends preview based on number of friends and spacing between cells
        let numFriendsInPreview = min(friends.count, 7) + 1
        let fullFriendsWidth = numFriendsInPreview * 20
        let overlapFriendsWidth = (numFriendsInPreview-1) * condensedCellSpacing * -1
        let friendsPreviewWidth = fullFriendsWidth - overlapFriendsWidth

        let padding = 20
        let userNameLabelWidth = Int(usernameLabel.frame.size.width)
        let userInfoViewWidth = userNameLabelWidth + padding + friendsPreviewWidth

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.centerX.equalToSuperview()
            make.size.equalTo(profileImageSize)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }

        usernameLabel.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.height.equalTo(15)
        }

        friendsPreviewView.snp.makeConstraints { make in
            make.leading.equalTo(usernameLabel.snp.trailing).offset(padding)
            make.top.bottom.height.equalToSuperview()
            make.width.equalTo(friendsPreviewWidth)
            make.height.equalTo(20)
        }

        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(userInfoViewWidth)
        }

        settingsButton.snp.makeConstraints { make in
            make.size.equalTo(sideButtonsSize)
            make.top.equalTo(view.snp.top).offset(28)
            make.trailing.equalToSuperview().inset(padding)
        }

        notificationButton.snp.makeConstraints { make in
            make.size.equalTo(sideButtonsSize)
            make.top.equalTo(settingsButton)
            make.trailing.equalTo(settingsButton.snp.leading).offset(-7)
        }

        listsContainerView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(30) //200 is temp
            make.leading.trailing.bottom.equalToSuperview()
        }

        addListButton.snp.makeConstraints { make in
            make.centerY.equalTo(listsContainerView.snp.top)
            make.trailing.equalTo(listsContainerView.snp.trailing).inset(40)
            make.size.equalTo(addListButtonSize)
        }

        listsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.trailing.bottom.equalToSuperview()
        }

    }

}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mediaLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: listCellReuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        cell.configure(for: mediaLists[indexPath.item], collaboratorsCellSpacing: expandedCellSpacing)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 174
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Update with selected list data
        let listViewController = ListViewController()
        navigationController?.pushViewController(listViewController, animated: true)
    }
}


