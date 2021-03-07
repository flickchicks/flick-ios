//
//  DiscoverViewController2.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

//enum DiscoverItemType {
//    case mutualFriends
//    case discoverShows
//    case discoverList
//    case buzz
//}
//
//protocol DiscoverItem {
//    var type: DiscoverItemType { get }
//    var sectionTitle: String { get }
//    var rowCount: Int { get }
//}

class DiscoverViewController2: UIViewController {

    // MARK: - Private View Vars
    private let discoverFeedTableView = UITableView(frame: .zero, style: .grouped)
    private let searchBar = SearchBar()
    private let refreshControl = UIRefreshControl()

    private var mutualFriends: [FriendRecommendation] = []
    private var shows: [SimpleMedia] = []
    private var lists: [MediaList] = []

    private let sections = [1,2,3,4,5,6,7,8]
    private var discoverSections: [String] = []
    private var discoverContent: [String: Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

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
        fetchDiscoverShows()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDiscoverShows()
    }

    func fetchDiscoverShows() {
        NetworkManager.discoverShows { [weak self] mediaList in
            guard let self = self else { return }

            var discoverContentSections: [String] = []

            if let mutualFriends = mediaList.friendRecommendations {
                discoverContentSections.append(MutualFriendsTableViewCell.reuseIdentifier)
                self.mutualFriends = mutualFriends
                print("We got mutual friends!!!")
            }

            if let friendLists = mediaList.friendsLsts {
                discoverContentSections.append(RecommendedListsTableViewCell.reuseIdentifier)
            }

            if let friendsShows = mediaList.friendShows {
                discoverContentSections.append(RecommendedShowsTableViewCell.reuseIdentifier)
            }

            discoverContentSections.append(RecommendedShowsTableViewCell.reuseIdentifier)
            self.shows = mediaList.trendingShows

            discoverContentSections.append(RecommendedListsTableViewCell.reuseIdentifier)
            self.lists = mediaList.trendingLsts

//            if let friendComments = mediaList.friendComments {
//            }

            self.discoverFeedTableView.reloadData()
        }
            



//            DispatchQueue.main.async {
//                mediaList.map { obj in
//                    print("here is obj", obj)
//                }
//                print(mediaList)
//                self.discoverShows[0] = mediaList.trendingTvs
//                self.discoverShows[1] = mediaList.trendingMovies
//                self.discoverShows[2] = mediaList.trendingAnimes
//                self.discoverFeedTableView.reloadData()
//                self.discoverFeedTableView.hideSkeleton()
//                // Maybe find better place to put this
//                self.refreshControl.endRefreshing()
//            }
//        }
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
            cell.configure(with: lists)
            return cell
        } else {
            return BuzzTableViewCell()
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
            return 300
        }
    }

}
