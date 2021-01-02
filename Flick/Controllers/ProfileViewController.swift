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

    // MARK: - Collection View Sections
    private struct Section {
        let type: SectionType
        var items: [SimpleMediaList]
    }

    private enum SectionType {
        case profileSummary
        case lists
    }

    // MARK: - Private View Vars
    private var listsTableView: UITableView!

    // MARK: - Private Data Vars
    private let headerReuseIdentifier = "HeaderReuseIdentifier"
    private let listCellReuseIdentifier = "ListCellReuseIdentifier"
    private let profileCellReuseIdentifier = "ProfileCellReuseIdentifier"
    private let userDefaults = UserDefaults()

    private var isCurrentUser = false
    private var mediaLists: [SimpleMediaList] = []
    private var sections = [Section]()
    private var user: UserProfile?
    private var userId: Int?

    // Use nil as userId if getting profile for current user
    init(userId: Int?) {
        super.init(nibName: nil, bundle: nil)
        self.isCurrentUser = userId == nil
        self.userId = userId
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .offWhite

        if !isCurrentUser {
            setupNavigationBar()
        }

        listsTableView = UITableView(frame: .zero, style: .plain)
        listsTableView.dataSource = self
        listsTableView.delegate = self
        listsTableView.register(ListTableViewCell.self, forCellReuseIdentifier: listCellReuseIdentifier)
        listsTableView.register(ProfileSummaryTableViewCell.self, forCellReuseIdentifier: profileCellReuseIdentifier)
        listsTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        listsTableView.separatorStyle = .none
        listsTableView.showsVerticalScrollIndicator = false
        listsTableView.bounces = false
        view.addSubview(listsTableView)

        listsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        setupSections()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let userId = userId, !isCurrentUser {
            getUser(userId: userId)
        } else {
            getCurrentUser()
        }
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .offWhite
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

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func setupSections() {
        let profileSummary = Section(type: SectionType.profileSummary, items: [])
        let lists = Section(type: SectionType.lists, items: mediaLists)
        sections = [profileSummary, lists]
    }

    private func getCurrentUser() {
        NetworkManager.getUserProfile { [weak self] userProfile in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateUserInfo(user: userProfile)
            }
        }
    }

    private func getUser(userId: Int) {
        NetworkManager.getUser(userId: userId) { [weak self] user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateUserInfo(user: user)
            }
        }
    }

    private func updateUserInfo(user: UserProfile) {
        self.user = user
        if let ownerLists = user.ownerLsts,
           let collabLists = user.collabLsts {
            self.mediaLists = ownerLists + collabLists
        }
        self.listsTableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .profileSummary:
            return 1
        case .lists:
            return mediaLists.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .profileSummary:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: profileCellReuseIdentifier, for: indexPath) as? ProfileSummaryTableViewCell else { return UITableViewCell() }
            cell.configure(isCurrentUser: isCurrentUser, user: user, delegate: self)
            return cell
        case .lists:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: listCellReuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
            cell.configure(for: mediaLists[indexPath.item])
            cell.delegate = self
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = sections[indexPath.section]
        switch section.type {
        case .profileSummary:
            return 160
        case .lists:
            return 174
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        switch section.type {
        case .profileSummary:
            return UIView()
        case .lists:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as? ProfileHeaderView else { return UIView() }
            headerView.configure(user: user, isCurrentUser: isCurrentUser)
            headerView.delegate = self
            return headerView
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = sections[section]
        switch section.type {
        case .profileSummary:
            return 0
        case .lists:
            return 80
        }
    }

}

extension ProfileViewController: ProfileDelegate, ModalDelegate, CreateListDelegate {

    func pushSettingsView() {
        let settingsViewController = SettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }

    func pushNotificationsView() {
        let allNotificationsViewController = AllNotificationsViewController()
        navigationController?.pushViewController(allNotificationsViewController, animated: true)
    }
    
    func pushFriendsView() {
        let friendsViewController = FriendsViewController()
        navigationController?.pushViewController(friendsViewController, animated: true)
    }

    func showCreateListModal() {
        let createListModalView = EnterListNameModalView(type: .createList)
        createListModalView.modalDelegate = self
        createListModalView.createListDelegate = self
        // TODO: Revisit if having multiple scenes becomes an issue (for ex. with iPad)
        if let window = UIApplication.shared.windows.first(where: { window -> Bool in window.isKeyWindow}) {
            // Add modal view to the window to also cover tab bar
            window.addSubview(createListModalView)
        }
    }

    func createFriendRequest() {
        guard let user = user else {
            presentInfoAlert(message: "Cannot send request", completion: nil)
            return
        }
        // Create friend request if not already friends and accept request if there's an incoming request
        switch user.friendStatus {
        case .notFriends:
            NetworkManager.createFriendRequest(friendId: user.id) { success in
                guard success else { return }
                self.presentInfoAlert(message: "Friend request sent", completion: nil)
                self.user?.friendStatus = .outgoingRequest
                DispatchQueue.main.async {
                    self.listsTableView.reloadData()
                }
            }
        case .incomingRequest:
            NetworkManager.acceptFriendRequest(friendId: user.id) { success in
                guard success else { return }
                self.presentInfoAlert(message: "Friend request accepted", completion: nil)
                self.user?.friendStatus = .friends
                DispatchQueue.main.async {
                    self.listsTableView.reloadData()
                }
            }
        default:
            break
        }
    }

    func createList(title: String) {
        NetworkManager.createNewMediaList(listName: title) { [weak self] mediaList in
            guard let self = self else { return }
            let listViewController = ListViewController(listId: mediaList.id)
            self.navigationController?.pushViewController(listViewController, animated: true)
        }
    }

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }
}

extension ProfileViewController: ListTableViewCellDelegate {

    func pushListViewController(listId: Int) {
        let listVC = ListViewController(listId: listId)
        navigationController?.pushViewController(listVC, animated: true)
    }

    func pushMediaViewController(mediaId: Int) {
        let mediaVC = MediaViewController(mediaId: mediaId)
        navigationController?.pushViewController(mediaVC, animated: true)
    }

}
