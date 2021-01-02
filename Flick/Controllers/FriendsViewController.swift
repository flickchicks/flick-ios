//
//  FriendsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 1/2/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    // MARK: - Private View Vars
    private let friendsTableView = UITableView(frame: .zero)
    private let headerView = UIView()
    private let friendsTitleLabel = UILabel()
    
    // MARK: - Private Data Vars
    private var friends: [UserProfile] = [
        UserProfile(
            id: 2,
            username: "username",
            firstName: "Haiying",
            lastName: "Weng",
            profilePic: nil,
            bio: nil,
            phoneNumber: nil,
            socialIdToken: nil,
            socialIdTokenType: nil,
            ownerLsts: nil,
            collabLsts: nil,
            numMutualFriends: nil
        ),
        UserProfile(
            id: 1,
            username: "username2",
            firstName: "Cindy",
            lastName: "Huang",
            profilePic: nil,
            bio: nil,
            phoneNumber: nil,
            socialIdToken: nil,
            socialIdTokenType: nil,
            ownerLsts: nil,
            collabLsts: nil,
            numMutualFriends: nil
        ),
        UserProfile(
            id: 5,
            username: "username2",
            firstName: "Cindy",
            lastName: "Huang",
            profilePic: nil,
            bio: nil,
            phoneNumber: nil,
            socialIdToken: nil,
            socialIdTokenType: nil,
            ownerLsts: nil,
            collabLsts: nil,
            numMutualFriends: nil
        ),
        UserProfile(
            id: 5,
            username: "username2",
            firstName: "Cindy",
            lastName: "Huang",
            profilePic: nil,
            bio: nil,
            phoneNumber: nil,
            socialIdToken: nil,
            socialIdTokenType: nil,
            ownerLsts: nil,
            collabLsts: nil,
            numMutualFriends: nil
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .offWhite
        setupNavigationBar()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.backgroundColor = .clear
        friendsTableView.separatorStyle = .none
        friendsTableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.reuseIdentifier)
        view.addSubview(friendsTableView)
        
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        headerView.backgroundColor = .movieWhite
        headerView.clipsToBounds = false
        headerView.layer.masksToBounds = false
        // TODO: Double check tab bar shadows
        headerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        headerView.layer.shadowOpacity = 0.07
        headerView.layer.shadowOffset = .init(width: 0, height: 4)
        headerView.layer.shadowRadius = 8
        view.addSubview(headerView)

        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(10)
        }

    }
    
    private func setupConstraints() {
        friendsTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Comment out networking for now since no friends
//        NetworkManager.getFriends { [weak self] friends in
//            guard let self = self else { return }
//            self.friends = friends
//            DispatchQueue.main.async {
//                self.friendsTableView.reloadData()
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        friendsTitleLabel.text = "My Friends"
        friendsTitleLabel.font = .systemFont(ofSize: 18)
        friendsTitleLabel.textColor = .black
        navigationController?.navigationBar.addSubview(friendsTitleLabel)

        friendsTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(59)
            make.top.bottom.trailing.equalToSuperview()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        friendsTitleLabel.removeFromSuperview()
    }
}


extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = friends[indexPath.row].id
        let profileViewController = ProfileViewController(userId: userId)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}

extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.reuseIdentifier, for: indexPath) as? FriendTableViewCell else { return UITableViewCell() }
        let friend = friends[indexPath.row]
        cell.configure(user: friend)
        return cell
    }
}
