//
//  DiscoverViewController.swift
//  Flick
//
//  Created by Lucy Xu on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SkeletonView

class DiscoverViewController: UIViewController {

    // MARK: - Private View Vars
    private let searchBar = SearchBar()
    private let discoverFeedTableView = UITableView(frame: .zero, style: .grouped)

    // MARK: - Private Data Vars
    private var discoverShows: [[SimpleMedia]] = [[], [], []]
    private var shouldAnimate = true

    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = .offWhite
        view.isSkeletonable = true

        searchBar.placeholder = "Search movies, shows, people, genres"
        searchBar.delegate = self
        view.addSubview(searchBar)

        discoverFeedTableView.dataSource = self
        discoverFeedTableView.delegate = self
        discoverFeedTableView.isSkeletonable = true
//        discoverFeedTableView.rowHeight = UITableView.automaticDimension
//        discoverFeedTableView.sectionHeaderHeight = UITableView.automaticDimension
        discoverFeedTableView.estimatedRowHeight = 500.0
        discoverFeedTableView.estimatedSectionHeaderHeight = 15.0
        discoverFeedTableView.backgroundColor = .clear
        discoverFeedTableView.showsVerticalScrollIndicator = false
        discoverFeedTableView.separatorStyle = .none
        discoverFeedTableView.register(DiscoverTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: DiscoverTableViewHeaderFooterView.reuseIdentifier)
        discoverFeedTableView.register(TrendingTableViewCell.self, forCellReuseIdentifier: TrendingTableViewCell.reuseIdentifier)
        view.addSubview(discoverFeedTableView)
        
        discoverFeedTableView.showAnimatedSkeleton(usingColor: .lightPurple, animation: .none, transition: .crossDissolve(0.25))
        
        setupConstraints()
    }

    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }

        discoverFeedTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkManager.discoverShows { [weak self] mediaList in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.discoverShows[0] = mediaList.trendingTvs
                self.discoverShows[1] = mediaList.trendingMovies
                self.discoverShows[2] = mediaList.trendingAnimes
                self.discoverFeedTableView.reloadData()
                self.discoverFeedTableView.hideSkeleton()
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

extension DiscoverViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return TrendingTableViewCell.reuseIdentifier
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.reuseIdentifier, for: indexPath) as? TrendingTableViewCell else { return UITableViewCell() }
        cell.configure(with: discoverShows[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return discoverShows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: DiscoverTableViewHeaderFooterView.reuseIdentifier) as? DiscoverTableViewHeaderFooterView else { return UITableViewHeaderFooterView() }
        if section == 0 {
            headerView.configure(with: "📺 Trending TV Shows")
        } else if section == 1 {
            headerView.configure(with: "🍿 Trending Movies")
        } else {
            headerView.configure(with: "🍙 Trending Anime")
        }
        return headerView
    }

}

extension DiscoverViewController: MediaControllerDelegate {
    func presentInfoAlert(message: String) {
        presentInfoAlert(message: message, completion: nil)
    }
    
    func showMediaViewController(id: Int) {
        let mediaViewController = MediaViewController(mediaId: id)
        navigationController?.pushViewController(mediaViewController, animated: true)
    }
}
