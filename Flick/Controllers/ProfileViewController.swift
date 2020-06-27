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

    private let media = Media(
        mediaId: "123",
        title: "Title",
        tags: ["tag"],
        posterPic: "null",
        director: "Director",
        isTV: false,
        dateReleased: "1/1/2020",
        status: "status",
        language: "language",
        duration: "duration",
        plot: "plot",
        keywords: ["keyword"],
        seasons: "4",
        audienceLevel: "audience",
        imbdRating: "4",
        friendsRating: "4",
        tomatoRating: "4",
        platforms: ["Netflix"]
    )

    private var mediaLists: [MediaList] = [
        MediaList(
            listId: "id",
            collaborators: ["A", "B", "C"],
            isPrivate: false,
            isFavorite: false,
            timestamp: "time",
            listName: "Saved",
            listPic: "null",
            tags: ["tag"],
            media: []
        ),
        MediaList(
            listId: "id",
            collaborators: [],
            isPrivate: true,
            isFavorite: false,
            timestamp: "time",
            listName: "Watchlist",
            listPic: "null",
            tags: ["tag"],
            media: []
        ),
        MediaList(
            listId: "id",
            collaborators: ["A", "B", "C", "D"],
            isPrivate: false,
            isFavorite: false,
            timestamp: "time",
            listName: "K Drama",
            listPic: "null",
            tags: ["tag"],
            media: []
        )
    ]

    override func viewDidLoad() {
        // TODO: Update with backend values
        mediaLists[0].media = [media,media,media,media,media,media,media,media]
        mediaLists[1].media = [media,media,media]
        mediaLists[2].media = [media,media,media,media,media,media,media,media]

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


