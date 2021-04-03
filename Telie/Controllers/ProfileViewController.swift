//
//  ProfileViewController.swift
//  Flick
//
//  Created by Lucy Xu on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SkeletonView

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
    private let listsTableView = UITableView(frame: .zero, style: .plain)
    private var bottomPaddingView = UIView()

    // MARK: - Private Data Vars
    private let headerReuseIdentifier = "HeaderReuseIdentifier"
    private let listCellReuseIdentifier = "ListCellReuseIdentifier"
    private let profileCellReuseIdentifier = "ProfileCellReuseIdentifier"

    private let currentUserId = UserDefaults.standard.integer(forKey: Constants.UserDefaults.userId)
    private var friends: [UserProfile] = []
    private var isCurrentUser: Bool = false
    private var isLikedSelected: Bool = false
    private var isHome: Bool = false
    private var likedLists: [SimpleMediaList] = []
    private var mediaLists: [SimpleMediaList] = []
    private var sections = [Section]()
    private let refreshControl = UIRefreshControl()
    private var user: UserProfile?
    private var userId: Int?

    // isHome is whether HomeViewController is displaying
    // userId is nil only if at HomeViewController
    init(isHome: Bool, userId: Int?) {
        super.init(nibName: nil, bundle: nil)
        self.isHome = isHome
        self.isCurrentUser = isHome || userId == currentUserId
        self.userId = userId
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        view.isSkeletonable = true
        
        // pad the bottom of view with white color so that table bouncing on bottom doesn't look weird
        bottomPaddingView.layer.zPosition = 0
        bottomPaddingView.backgroundColor = .white
        view.addSubview(bottomPaddingView)

        refreshControl.addTarget(self, action: #selector(refreshProfile), for: .valueChanged)

        listsTableView.dataSource = self
        listsTableView.delegate = self
        listsTableView.backgroundColor = .clear
        listsTableView.register(ListTableViewCell.self, forCellReuseIdentifier: listCellReuseIdentifier)
        listsTableView.register(ProfileSummaryTableViewCell.self, forCellReuseIdentifier: profileCellReuseIdentifier)
        listsTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        // TODO: Removing height seems to have fix the profile loading skeleton dimensions but causes constraint errors
//        listsTableView.estimatedRowHeight = 185
        listsTableView.rowHeight = UITableView.automaticDimension
        listsTableView.bounces = true
        listsTableView.separatorStyle = .none
        listsTableView.estimatedSectionHeaderHeight = 0
        listsTableView.sectionHeaderHeight = UITableView.automaticDimension
        listsTableView.showsVerticalScrollIndicator = false
        listsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        listsTableView.isSkeletonable = true

        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            listsTableView.refreshControl = refreshControl
        } else {
            listsTableView.addSubview(refreshControl)
        }

        view.addSubview(listsTableView)

        setupConstraints()
        setupSections()

        listsTableView.showAnimatedSkeleton(usingColor: .lightPurple, animation: .none, transition: .crossDissolve(0.25))
    }

    private func setupConstraints() {
        listsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }

        bottomPaddingView.snp.makeConstraints { make in
            make.height.equalTo(view.frame.height - 310)
            make.leading.trailing.bottom.equalTo(listsTableView)
        }

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isHome {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            setupNavigationBar()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateUser()
    }
    
    private func updateUser() {
        if isCurrentUser {
            getCurrentUser()
        } else if let userId = userId {
            getUser(userId: userId)
        }
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .offWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowOpacity = 0.0

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
    
    @objc func refreshProfile() {
        updateUser()
        if isLikedSelected {
            getLikedLists()
        }
    }

    private func setupSections() {
        let profileSummary = Section(type: SectionType.profileSummary, items: [])
        let lists = Section(type: SectionType.lists, items: mediaLists)
        sections = [profileSummary, lists]
    }

    private func getCurrentUser() {
        // Get profile of current user
        NetworkManager.getUserProfile { [weak self] userProfile in
            guard let self = self, let userProfile = userProfile else { return }
            UserDefaults.standard.set(userProfile.id, forKey: Constants.UserDefaults.userId)
            DispatchQueue.main.async {
                self.updateUserInfo(user: userProfile)
            }
        }

        // Get friends of current user
        NetworkManager.getFriends { [weak self] friends in
            guard let self = self, !friends.isEmpty else { return }
            self.friends = friends
            DispatchQueue.main.async {
                self.listsTableView.reloadSections(IndexSet([0]), with: .none)
                self.refreshControl.endRefreshing()
            }
        }
    }

    private func getUser(userId: Int) {
        // Get profile of another user
        NetworkManager.getUser(userId: userId) { [weak self] user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateUserInfo(user: user)
            }
        }

        // Get friends of another user
        NetworkManager.getFriendsOfUser(userId: userId) { [weak self] friends in
            guard let self = self, !friends.isEmpty else { return }
            self.friends = friends
            DispatchQueue.main.async {
                self.listsTableView.reloadSections(IndexSet([0]), with: .none)
                self.refreshControl.endRefreshing()
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
        self.listsTableView.hideSkeleton()

        // Change notification tab icon image if there's any notifications
        if isCurrentUser,
           let tabItems = tabBarController?.tabBar.items {
            let notificationItem = tabItems[3]
            if let numNotifs = user.numNotifs {
                let imageName = numNotifs > 0 ? "activeNotificationIcon" : "notificationIcon"
                notificationItem.image = UIImage(named: imageName)
            }
        }
        refreshControl.endRefreshing()
    }

    private func getLikedLists() {
        guard let user = user else { return }
        NetworkManager.getLikedLists(userId: user.id) { [weak self] likedLists in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.likedLists = likedLists
                self.listsTableView.reloadData()
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Only allow bouncing for top of scroll view
        if scrollView.contentOffset.y > 10 {
            listsTableView.bounces = false
        } else {
            listsTableView.bounces = true
        }
        if scrollView.contentOffset.y < -170 {
            scrollView.contentOffset = CGPoint(x: 0, y: -170)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, SkeletonTableViewDataSource {

    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let section = sections[indexPath.section]
        switch section.type {
        case .profileSummary:
            return profileCellReuseIdentifier
        case .lists:
            return listCellReuseIdentifier
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .profileSummary:
            return 1
        case .lists:
            return 3
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .profileSummary:
            return 1
        case .lists:
            return isLikedSelected ? likedLists.count : mediaLists.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .profileSummary:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: profileCellReuseIdentifier, for: indexPath) as? ProfileSummaryTableViewCell else { return UITableViewCell() }
            cell.configure(isHome: isHome,
                           user: user,
                           friends: friends,
                           delegate: self)
            return cell
        case .lists:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: listCellReuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
            cell.configure(for: isLikedSelected ? likedLists[indexPath.item] : mediaLists[indexPath.item])
            cell.delegate = self
            return cell
        }
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return sections.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, identifierForHeaderInSection section: Int) -> ReusableHeaderFooterIdentifier? {
        let section = sections[section]
        switch section.type {
        case .lists:
            return headerReuseIdentifier
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        switch section.type {
        case .profileSummary:
            return UIView()
        case .lists:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as? ProfileHeaderView else { return UIView() }
            headerView.configure(user: user,
                                 isCurrentUser: isCurrentUser)
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
            return 95
        }
    }

}

extension ProfileViewController: ProfileDelegate, ModalDelegate, CreateListDelegate {

    func pushSettingsView() {
        guard let user = user else { return }
        let settingsViewController = SettingsViewController(user: user)
        navigationController?.pushViewController(settingsViewController, animated: true)
    }

    func pushNotificationsView() {
        let allNotificationsViewController = AllNotificationsViewController()
        navigationController?.pushViewController(allNotificationsViewController, animated: true)
    }
    
    func pushFriendsView() {
        let usersViewController = UsersViewController(isCollaborators: false, users: friends)
        navigationController?.pushViewController(usersViewController, animated: true)
    }

    func showCreateListModal() {
        let createListModalView = EnterNameModalView(type: .createList)
        createListModalView.modalDelegate = self
        createListModalView.createListDelegate = self
        showModalPopup(view: createListModalView)
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

    func showLists() {
        isLikedSelected = false
        listsTableView.reloadData()
    }

    func showLikedLists() {
        isLikedSelected = true
        listsTableView.reloadData()
        getLikedLists()
    }
}

extension ProfileViewController: ListTableViewCellDelegate {

    func pushListViewController(listId: Int) {
        let listVC = ListViewController(listId: listId)
        navigationController?.pushViewController(listVC, animated: true)
    }

    func pushMediaViewController(mediaId: Int, mediaImageUrl: String?) {
        let mediaVC = MediaViewController(mediaId: mediaId, mediaImageUrl: mediaImageUrl)
        navigationController?.pushViewController(mediaVC, animated: true)
    }

}
