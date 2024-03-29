//
//  AddMembersToGroupsViewController.swift
//  Flick
//
//  Created by Haiying W on 1/27/21.
//  Copyright © 2021 flick. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

protocol AddMembersDelegate: class {
    func reloadGroupMembers(group: Group)
}

class AddMembersToGroupsViewController: UIViewController {

    // MARK: - Private View Vars
    private let searchBar = SearchBar()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 30, height: 30),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let titleLabel = UILabel()
    private let usersTableView = UITableView()

    // MARK: - Data Vars
    weak var delegate: AddMembersDelegate?
    private var friends: [UserProfile] = []
    private var group: Group
    private var isSearching: Bool = false
    private var timer: Timer?
    private var users: [UserProfile] = []

    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {

        view.backgroundColor = .white

        titleLabel.text = "Add members"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        view.addSubview(titleLabel)

        searchBar.placeholder = "Search"
        searchBar.delegate = self
        view.addSubview(searchBar)

        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.showsVerticalScrollIndicator = false
        usersTableView.register(EditUserTableViewCell.self, forCellReuseIdentifier: EditUserTableViewCell.reuseIdentifier)
        usersTableView.separatorStyle = .none
        usersTableView.keyboardDismissMode = .onDrag
        view.addSubview(usersTableView)

        view.addSubview(spinner)

        if friends.isEmpty {
            spinner.startAnimating()
        }

        setupConstraints()

        NetworkManager.getFriends { [weak self] friends in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.friends = friends
                self.spinner.stopAnimating()
                self.usersTableView.reloadData()
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let horizontalPadding = 22
        let verticalPadding = 36

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalPadding)
            make.leading.equalToSuperview().offset(horizontalPadding)
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

        spinner.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usersTableView)
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

extension AddMembersToGroupsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? users.count : friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditUserTableViewCell.reuseIdentifier, for: indexPath) as? EditUserTableViewCell else { return UITableViewCell() }
        let user = isSearching ? users[indexPath.row] : friends[indexPath.row]
        let isAdded = (group.members ?? []).contains { user.id == $0.id }
        cell.configureForAdd(user: user, editMode: .add, isAdded: isAdded)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }

}

extension AddMembersToGroupsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

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

extension AddMembersToGroupsViewController: EditUserCellDelegate {

    func addUserTapped(user: UserProfile) {
        NetworkManager.addToGroup(id: group.id, memberIds: [user.id]) { [weak self] group in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.group = group
                // Reload table view row for added user
                if self.isSearching {
                    self.users.enumerated().forEach { (index, resultUser) in
                        if user.id == resultUser.id {
                            self.usersTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        }
                    }
                } else {
                    self.friends.enumerated().forEach { (index, friend) in
                        if user.id == friend.id {
                            self.usersTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        }
                    }
                }
                self.delegate?.reloadGroupMembers(group: group)
            }
        }
    }

    func removeUserTapped(user: UserProfile) {
        print("Remove user tapped")
    }

}
