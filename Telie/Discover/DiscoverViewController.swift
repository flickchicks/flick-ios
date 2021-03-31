//
//  DiscoverViewController.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import Hero
import NVActivityIndicatorView
import UIKit

enum DiscoverSection {
    case friendRecommendations,
         friendShows,
         friendLsts,
         trendingLsts,
         trendingShows,
         buzz,
         footer

    func reuseIdentifier() -> String {
        switch self {
        case .friendRecommendations:
            return MutualFriendsTableViewCell.reuseIdentifier
        case .friendShows, .trendingShows:
            return RecommendedShowsTableViewCell.reuseIdentifier
        case .friendLsts, .trendingLsts:
            return RecommendedListsTableViewCell.reuseIdentifier
        case .buzz:
            return BuzzTableViewCell.reuseIdentifier
        case .footer:
            return DiscoverFooterTableViewCell.reuseIdentifier
        }
    }
}

class DiscoverViewController: UIViewController {

    // MARK: - Private View Vars
    private var discoverContent: DiscoverContent? = nil
    private let discoverFeedTableView = UITableView(frame: .zero, style: .grouped)
    private var discoverSections: [DiscoverSection] = []
    private let searchBar = SearchBar()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 30, height: 30),
        type: .circleStrokeSpin,
        color: .gradientPurple
    )
    private let refreshControl = UIRefreshControl()

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
        discoverFeedTableView.register(DiscoverFooterTableViewCell.self, forCellReuseIdentifier: DiscoverFooterTableViewCell.reuseIdentifier)

        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            discoverFeedTableView.refreshControl = refreshControl
        } else {
            discoverFeedTableView.addSubview(refreshControl)
        }

        view.addSubview(discoverFeedTableView)

        view.addSubview(spinner)
        spinner.startAnimating()

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

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
        NetworkManager.discoverShows { [weak self] discoverContent in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.discoverSections = []
                self.discoverContent = discoverContent

                if discoverContent.friendRecommendations.count > 0 {
                    self.discoverSections.append(.friendRecommendations)
                }

                if discoverContent.friendShows.count > 0 {
                    self.discoverSections.append(.friendShows)
                }

                if discoverContent.friendLsts.count > 0 {
                    self.discoverSections.append(.friendLsts)
                }

                let numFriendComments = discoverContent.friendComments.count
                if numFriendComments > 0 {
                    self.discoverSections.append(contentsOf: repeatElement(.buzz, count: numFriendComments))
                }

                self.discoverSections.append(.trendingLsts)
                self.discoverSections.append(.trendingShows)
                self.discoverSections.append(.footer)

                self.spinner.stopAnimating()
                self.refreshControl.endRefreshing()
                self.discoverFeedTableView.reloadData()
            }
        }
    }
}

extension DiscoverViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let searchVC = DiscoverSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
        return false
    }
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoverSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let discoverContent = discoverContent else { return UITableViewCell() }

        let section = discoverSections[indexPath.row]
        let reuseIdentifier = section.reuseIdentifier()

        switch section {
        case .friendRecommendations:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
                    as? MutualFriendsTableViewCell else { return UITableViewCell() }
            cell.configure(with: discoverContent.friendRecommendations)
            cell.discoverDelegate = self
                return cell
        case .friendLsts:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
                    as? RecommendedListsTableViewCell else { return UITableViewCell() }
            cell.configure(with: discoverContent.friendLsts, header: "📔 Lists You'll Love")
            cell.discoverDelegate = self
            return cell
        case .friendShows:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
                    as? RecommendedShowsTableViewCell else { return UITableViewCell() }
            cell.configure(with: discoverContent.friendShows, header: "📺 Picks for You")
            cell.discoverDelegate = self
            return cell
        case .trendingLsts:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
                    as? RecommendedListsTableViewCell else { return UITableViewCell() }
            cell.configure(with: discoverContent.trendingLsts, header: "🔥 Trending Lists")
            cell.discoverDelegate = self
            return cell
        case .trendingShows:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
                    as? RecommendedShowsTableViewCell else { return UITableViewCell() }
            cell.configure(with: discoverContent.trendingShows, header: "🍿 Trending Shows")
            cell.discoverDelegate = self
            return cell
        case .buzz:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
                    as? BuzzTableViewCell else { return UITableViewCell() }
            cell.configure(with: (discoverContent.friendComments[indexPath.row - 3]))
            cell.discoverDelegate = self
            return cell
        case .footer:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
                    as? DiscoverFooterTableViewCell else { return UITableViewCell() }
            return cell
        }
    }
}

extension DiscoverViewController: DiscoverDelegate {
    func navigateFriend(id: Int) {
        let profileViewController = ProfileViewController(isHome: false, userId: id)
        navigationController?.pushViewController(profileViewController, animated: true)
    }

    func navigateShow(id: Int, mediaImageUrl: String?) {
        navigationController?.pushViewController(MediaViewController(mediaId: id, mediaImageUrl: mediaImageUrl), animated: true)
    }

    func navigateList(id: Int) {
        navigationController?.pushViewController(ListViewController(listId: id), animated: true)
    }
}
