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

    // MARK: - Private Data Vars
    private var friends: [UserProfile] = []

    init(friends: [UserProfile]) {
        self.friends = friends
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Friends"
        view.backgroundColor = .offWhite

        headerView.backgroundColor = .movieWhite
        headerView.clipsToBounds = false
        headerView.layer.masksToBounds = false
        headerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        headerView.layer.shadowOpacity = 0.07
        headerView.layer.shadowOffset = .init(width: 0, height: 4)
        headerView.layer.shadowRadius = 8
        view.addSubview(headerView)

        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        friendsTableView.backgroundColor = .clear
        friendsTableView.separatorStyle = .none
        friendsTableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.reuseIdentifier)
        view.addSubview(friendsTableView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.setNavigationBarHidden(false, animated: true)
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
    }

    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(10)
        }

        friendsTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

}

extension FriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = friends[indexPath.row].id
        let profileViewController = ProfileViewController(isHome: false, userId: userId)
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
