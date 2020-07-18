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
        var items: [MediaList]
    }

    private enum SectionType {
        case profileSummary
        case lists
    }

    // MARK: - Private View Vars
    private var listsTableView: UITableView!

    // MARK: - Private Data Vars
    private var expandedCellSpacing = -5
    private let headerReuseIdentifier = "HeaderReuseIdentifier"
    private let listCellReuseIdentifier = "ListCellReuseIdentifier"
    private let profileCellReuseIdentifier = "ProfileCellReuseIdentifier"
    private var sections = [Section]()

    private let userDefaults = UserDefaults()
    // TODO: Update media lists with backend lists
    private var mediaLists: [MediaList] = []
    private var name: String = ""
    private var username: String = ""
    private var profilePicUrl: String = ""

    override func viewDidLoad() {

        super.viewDidLoad()

        view.backgroundColor = .offWhite

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getUserProfile()
    }

    private func setupSections() {
        let profileSummary = Section(type: SectionType.profileSummary, items: [])
        let lists = Section(type: SectionType.lists, items: mediaLists)
        sections = [profileSummary, lists]
    }

    private func getUserProfile() {
        if let authToken = userDefaults.string(forKey: Constants.UserDefaults.authorizationToken) {
            NetworkManager.getUserProfile(authToken: authToken) { userProfile in
                self.name = "\(userProfile.firstName) \(userProfile.lastName)"
                self.username = userProfile.username
                self.profilePicUrl = userProfile.profilePic.assetUrls.original
                // TODO: Ask Alanna about combining ownerLsts and collaboratorLsts
                if let ownerLsts = userProfile.ownerLsts {
                    self.mediaLists = ownerLsts
                }
                self.listsTableView.reloadData()
            }
        }
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
            cell.configure(name: name, username: username, profilePicUrl: profilePicUrl)
            return cell
        case .lists:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: listCellReuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
            cell.configure(for: mediaLists[indexPath.item], collaboratorsCellSpacing: expandedCellSpacing)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Update with selected list data
        let listViewController = ListViewController(list: mediaLists[indexPath.row])
        navigationController?.pushViewController(listViewController, animated: true)
    }

}

extension ProfileViewController: ProfileDelegate, ModalDelegate, ListDelegate {

    func showCreateListModal() {
        let createListModalView = EnterListNameModalView(type: .createList)
        createListModalView.modalDelegate = self
        createListModalView.listDelegate = self
        // TODO: Revisit if having multiple scenes becomes an issue (for ex. with iPad)
        if let window = UIApplication.shared.windows.first(where: { window -> Bool in window.isKeyWindow}) {
            // Add modal view to the window to also cover tab bar
            window.addSubview(createListModalView)
        }
    }

    func createList(title: String) {
        if let authToken = userDefaults.string(forKey: Constants.UserDefaults.authorizationToken) {
            NetworkManager.createNewMediaList(authToken: authToken, listName: title) { mediaList in
                let listViewController = ListViewController(list: mediaList)
                self.navigationController?.pushViewController(listViewController, animated: true)
            }
        }
    }

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }
}

