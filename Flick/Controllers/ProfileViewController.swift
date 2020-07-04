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
    private var mediaLists: [MediaList] = []
    private var name: String = ""
    private var username: String = ""
    private var profilePicUrl: String = ""

    override func viewDidLoad() {

        if let authToken = userDefaults.string(forKey: "authorizationToken") {
            print("value exists")
            NetworkManager.getUserProfile(authToken: authToken) { userProfile in
                print("completion")
                self.name = "\(userProfile.firstName) \(userProfile.lastName)"
                self.username = userProfile.username
                self.profilePicUrl = userProfile.profilePic.assetUrls.original
                self.listsTableView.reloadData()
            }
        }

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

    private func setupSections() {
        let profileSummary = Section(type: SectionType.profileSummary, items: [])
        let lists = Section(type: SectionType.lists, items: mediaLists)
        sections = [profileSummary, lists]
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
            return section.items.count
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
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerReuseIdentifier) as? ProfileHeaderView
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
        let listViewController = ListViewController()
        navigationController?.pushViewController(listViewController, animated: true)
    }

}


