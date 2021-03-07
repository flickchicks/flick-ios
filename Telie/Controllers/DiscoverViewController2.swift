//
//  DiscoverViewController2.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

enum DiscoverItemType {
    case mutualFriends
    case discoverShows
    case discoverList
    case buzz
}

protocol DiscoverItem {
    var type: DiscoverItemType { get }
    var sectionTitle: String { get }
    var rowCount: Int { get }
}

class DiscoverViewController2: UIViewController {

    // MARK: - Private View Vars
    private let discoverFeedTableView = UITableView(frame: .zero, style: .grouped)
    private let searchBar = SearchBar()
    private let refreshControl = UIRefreshControl()

    private var mutualFriends: [MutualFriend] = [
        MutualFriend(name: "Lucy Xu", profile: "", username: "lucyxu", numMutual: 5),
        MutualFriend(name: "Haiying Weng", profile: "", username: "haiyingweng", numMutual: 2),
        MutualFriend(name: "Alanna Zhou", profile: "", username: "alannazhou", numMutual: 9),
        MutualFriend(name: "Cindy Huang", profile: "", username: "cindyhuang", numMutual: 4),
        MutualFriend(name: "Olivia Li", profile: "", username: "oliviali", numMutual: 2),
        MutualFriend(name: "Vivi Yue", profile: "", username: "viviyue", numMutual: 9)
    ]

    private var shows: [SimpleMedia] = [
        SimpleMedia(id: 0, title: "Media", posterPic: ""),
        SimpleMedia(id: 0, title: "Media", posterPic: ""),
        SimpleMedia(id: 0, title: "Media", posterPic: ""),
        SimpleMedia(id: 0, title: "Media", posterPic: ""),
        SimpleMedia(id: 0, title: "Media", posterPic: ""),
        SimpleMedia(id: 0, title: "Media", posterPic: ""),
        SimpleMedia(id: 0, title: "Media", posterPic: "")
    ]

    private var sections = [1, 2, 3]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        view.isSkeletonable = true

        searchBar.placeholder = "Search movies, shows, people, lists"
        searchBar.delegate = self
        view.addSubview(searchBar)

        refreshControl.addTarget(self, action: #selector(refreshDiscoverData), for: .valueChanged)

        discoverFeedTableView.dataSource = self
        discoverFeedTableView.delegate = self
        discoverFeedTableView.estimatedRowHeight = 500.0
        discoverFeedTableView.estimatedSectionHeaderHeight = 15.0
        discoverFeedTableView.backgroundColor = .clear
        discoverFeedTableView.showsVerticalScrollIndicator = false
        discoverFeedTableView.separatorStyle = .none
        discoverFeedTableView.register(MutualFriendsTableViewCell.self, forCellReuseIdentifier: MutualFriendsTableViewCell.reuseIdentifier)
        discoverFeedTableView.register(RecommendedShowsTableViewCell.self, forCellReuseIdentifier: RecommendedShowsTableViewCell.reuseIdentifier)
        discoverFeedTableView.register(RecommendedListsTableViewCell.self, forCellReuseIdentifier: RecommendedListsTableViewCell.reuseIdentifier)

        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            discoverFeedTableView.refreshControl = refreshControl
        } else {
            discoverFeedTableView.addSubview(refreshControl)
        }

        view.addSubview(discoverFeedTableView)

        setupConstraints()
    }

    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        discoverFeedTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    @objc func refreshDiscoverData() {
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}

extension DiscoverViewController2: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = DiscoverSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
        return false
    }

}

extension DiscoverViewController2: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MutualFriendsTableViewCell.reuseIdentifier, for: indexPath) as? MutualFriendsTableViewCell else { return UITableViewCell() }
            cell.configure(with: mutualFriends)
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedShowsTableViewCell.reuseIdentifier, for: indexPath) as? RecommendedShowsTableViewCell else { return UITableViewCell() }
            cell.configure(with: shows)
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedListsTableViewCell.reuseIdentifier, for: indexPath) as? RecommendedListsTableViewCell else { return UITableViewCell() }
            cell.configure(with: shows)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else if indexPath.row == 1 {
            return 575
        } else if indexPath.row == 2 {
            return 620
        } else {
            return 100
        }
    }

}
