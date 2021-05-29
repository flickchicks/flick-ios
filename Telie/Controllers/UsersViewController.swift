//
//  UsersViewController.swift
//  Flick
//
//  Created by Lucy Xu on 1/2/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    // MARK: - Private View Vars
    private let usersTableView = UITableView(frame: .zero)

    // MARK: - Private Data Vars
    private let searchBar = SearchBar()
    private var allUsers: [UserProfile]
    private var users: [UserProfile]
    private var userId: Int?
    private var isCollaborators: Bool
    private var isCurrentUser: Bool

    init(isCollaborators: Bool, users: [UserProfile], userId: Int?, isCurrentUser: Bool) {
        self.users = isCollaborators ? users : []
        self.allUsers = isCollaborators ? users : []
        self.userId = userId
        self.isCollaborators = isCollaborators
        self.isCurrentUser = isCurrentUser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = isCollaborators ? "Collaborators" : "Friends"
        view.backgroundColor = .offWhite

        searchBar.placeholder = "Search"
        searchBar.delegate = self
        view.addSubview(searchBar)

        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.backgroundColor = .clear
        usersTableView.separatorStyle = .none
        usersTableView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 12, right: 0)
        usersTableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        view.addSubview(usersTableView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        if !isCollaborators {
            getFriends()
        }
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.07
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationController?.navigationBar.layer.shadowRadius = 8
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18)
        }

        usersTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(8)
        }
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    func getFriends() {
        if isCurrentUser {
            NetworkManager.getFriends { [weak self] friends in
                guard let self = self, !friends.isEmpty else { return }
                self.users = friends
                self.allUsers = friends
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            }
        } else {
            guard let userId = userId else { return }
            NetworkManager.getFriendsOfUser(userId: userId) { [weak self] friends in
                guard let self = self else { return }
                self.users = friends
                self.allUsers = friends
                DispatchQueue.main.async {
                    self.usersTableView.reloadData()
                }
            }
        }
    }

}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = users[indexPath.row].id
        let profileViewController = ProfileViewController(isHome: false, userId: userId)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.configure(user: user)
        return cell
    }
}

extension UsersViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            users = allUsers
        } else {
            users = users.filter { user in
                return user.name.contains(searchText) || user.username.contains(searchText)
            }
        }
        usersTableView.reloadData()
    }

}
