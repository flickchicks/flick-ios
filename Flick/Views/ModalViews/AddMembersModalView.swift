//
//  AddMembersModalView.swift
//  Flick
//
//  Created by Haiying W on 1/27/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class AddMembersModalView: ModalView {

    // MARK: - Private View Vars
    private let searchBar = SearchBar()
    private let titleLabel = UILabel()
    private let usersTableView = UITableView()

    // MARK: - Private Data Vars
    private var friends: [UserProfile] = []
    private var isSearching: Bool = false
    private var timer: Timer?
    private var users: [UserProfile] = []
    private let usersCellReuseIdentifier = "UsersCellReuseIdentifier"

    override init() {
        super.init()

        titleLabel.text = "Add members"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(titleLabel)

        searchBar.placeholder = "Search"
        searchBar.delegate = self
        containerView.addSubview(searchBar)

        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.showsVerticalScrollIndicator = false
        usersTableView.register(EditCollaboratorTableViewCell.self, forCellReuseIdentifier: usersCellReuseIdentifier)
        usersTableView.separatorStyle = .none
        usersTableView.keyboardDismissMode = .onDrag
        containerView.addSubview(usersTableView)

        setupConstraints()

        NetworkManager.getFriends { [weak self] friends in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.friends = friends
                self.usersTableView.reloadData()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let containerViewSize = CGSize(width: 325, height: 460)
        let horizontalPadding = 22
        let verticalPadding = 36

        containerView.snp.makeConstraints { make in
            make.size.equalTo(containerViewSize)
            make.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(verticalPadding)
            make.leading.equalTo(containerView).offset(horizontalPadding)
            make.height.equalTo(22)
        }

        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(40)
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
        }

        usersTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(searchBar.snp.bottom).offset(18)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }
    }

    @objc private func searchUsers(timer: Timer) {
        if let userInfo = timer.userInfo as? [String: String],
            let searchText = userInfo["searchText"] {
            NetworkManager.searchUsers(query: searchText) { [weak self] users in
                guard let self = self, self.isSearching else { return }
                DispatchQueue.main.async {
                    self.users = users
                    self.usersTableView.reloadData()
                }
            }
        }
    }

}

extension AddMembersModalView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? users.count : friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: usersCellReuseIdentifier, for: indexPath) as? EditCollaboratorTableViewCell else { return UITableViewCell() }
        let user = isSearching ? users[indexPath.row] : friends[indexPath.row]
        cell.configureFriend(for: user, isAdded: false) // false is temp
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }

}

extension AddMembersModalView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            DispatchQueue.main.async {
                self.usersTableView.reloadData()
            }
        } else {
            isSearching = true
            timer?.invalidate()
            timer = Timer.scheduledTimer(
                timeInterval: 0.2,
                target: self,
                selector: #selector(searchUsers),
                userInfo: ["searchText": searchText],
                repeats: false
            )
        }
    }

}
