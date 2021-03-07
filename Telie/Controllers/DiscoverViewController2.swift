//
//  DiscoverViewController2.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

class DiscoverViewController2: UIViewController {

    // MARK: - Private View Vars
    private let discoverFeedTableView = UITableView(frame: .zero, style: .grouped)
    private let searchBar = SearchBar()
    private let refreshControl = UIRefreshControl()
    private var discoverContent: DiscoverContent? = nil
    private var discoverSectionsArray: [String] = []
    private var discoverSections: [String: String] = [
        "friendRecs" : MutualFriendsTableViewCell.reuseIdentifier,
        "friendShows": RecommendedShowsTableViewCell.reuseIdentifier,
        "friendLsts": RecommendedListsTableViewCell.reuseIdentifier,
        "trendingLsts": RecommendedListsTableViewCell.reuseIdentifier,
        "trendingShows": RecommendedShowsTableViewCell.reuseIdentifier,
        "buzz": BuzzTableViewCell.reuseIdentifier
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        searchBar.placeholder = "Search movies, shows, people, lists"
        searchBar.delegate = self
        view.addSubview(searchBar)

        refreshControl.addTarget(self, action: #selector(refreshDiscoverData), for: .valueChanged)

        discoverFeedTableView.dataSource = self
        discoverFeedTableView.delegate = self
        discoverFeedTableView.rowHeight = UITableView.automaticDimension
        discoverFeedTableView.estimatedRowHeight = 500.0
        discoverFeedTableView.estimatedSectionHeaderHeight = 15.0
        discoverFeedTableView.backgroundColor = .clear
        discoverFeedTableView.showsVerticalScrollIndicator = false
        discoverFeedTableView.separatorStyle = .none
        discoverFeedTableView.register(MutualFriendsTableViewCell.self, forCellReuseIdentifier: MutualFriendsTableViewCell.reuseIdentifier)
        discoverFeedTableView.register(RecommendedShowsTableViewCell.self, forCellReuseIdentifier: RecommendedShowsTableViewCell.reuseIdentifier)
        discoverFeedTableView.register(RecommendedListsTableViewCell.self, forCellReuseIdentifier: RecommendedListsTableViewCell.reuseIdentifier)
        discoverFeedTableView.register(BuzzTableViewCell.self, forCellReuseIdentifier: BuzzTableViewCell.reuseIdentifier)

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

            DispatchQueue.main.async {
                self.discoverContent = mediaList

                if mediaList.friendRecommendations.count > 0 {
                    self.discoverSectionsArray.append("friendRecs")
                }

                if mediaList.friendShows.count > 0 {
                    self.discoverSectionsArray.append("friendShows")
                }

                if mediaList.friendLsts.count > 0 {
                    self.discoverSectionsArray.append("friendLsts")
                }

                let numFriendComments = mediaList.friendComments.count
                if numFriendComments > 0 {
                    self.discoverSectionsArray.append(contentsOf: repeatElement("buzz", count: numFriendComments))
                }

                self.discoverSectionsArray.append("trendingLsts")
                self.discoverSectionsArray.append("trendingShows")
                self.discoverFeedTableView.reloadData()
            }
        }
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
        return discoverSectionsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < discoverSectionsArray.count,
              let reuseIdentifier = discoverSections[discoverSectionsArray[indexPath.row]] else { return UITableViewCell() }

        switch discoverSectionsArray[indexPath.row] {
        case "friendRecs":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MutualFriendsTableViewCell else { return UITableViewCell() }
            cell.configure(with: discoverContent?.friendRecommendations ?? [])
                return cell
        case "friendLsts":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? RecommendedListsTableViewCell else { return UITableViewCell() }
            cell.configure(with: discoverContent?.friendLsts ?? [])
            return cell
        case "friendShows":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? RecommendedShowsTableViewCell else { return UITableViewCell() }
            cell.configure(with: discoverContent?.friendShows ?? [])
            return cell
        case "trendingLsts":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? RecommendedListsTableViewCell else { return UITableViewCell() }
            cell.configure(with: discoverContent?.trendingLsts ?? [])
            return cell
        case "trendingShows":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? RecommendedShowsTableViewCell else { return UITableViewCell() }
            cell.configure(with: discoverContent?.trendingShows ?? [])
            return cell
        case "buzz":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? BuzzTableViewCell else { return UITableViewCell() }
            cell.configure(with: (discoverContent?.friendComments[indexPath.row - 3])!)
            return cell
        default:
            return UITableViewCell()
        }

    }

}
