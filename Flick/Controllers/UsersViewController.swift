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
    private var users: [UserProfile] = []
    private var isCollaborators: Bool

    init(isCollaborators: Bool, users: [UserProfile]) {
        self.users = users
        self.isCollaborators = isCollaborators
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = isCollaborators ? "Collaborators" : "Friends"
        view.backgroundColor = .offWhite

        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.backgroundColor = .clear
        usersTableView.separatorStyle = .none
        usersTableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        view.addSubview(usersTableView)

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
        usersTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
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
