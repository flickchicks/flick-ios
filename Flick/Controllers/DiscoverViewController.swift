//
//  DiscoverViewController.swift
//  Flick
//
//  Created by Lucy Xu on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    // MARK: - Private View Vars
    private let searchBar = SearchBar()
    private let discoverFeedTableView = UITableView(frame: .zero, style: .grouped)

    // MARK: - Private Data Vars
    private var discoverShows: [[SimpleMedia]] = [[], [], []]

    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = .offWhite

        searchBar.placeholder = "Search movies, shows, people, genres"
        searchBar.delegate = self
        view.addSubview(searchBar)

        discoverFeedTableView.dataSource = self
        discoverFeedTableView.delegate = self
        discoverFeedTableView.backgroundColor = .clear
        discoverFeedTableView.showsVerticalScrollIndicator = false
        discoverFeedTableView.separatorStyle = .none
        discoverFeedTableView.register(DiscoverTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: DiscoverTableViewHeaderFooterView.reuseIdentifier)
        discoverFeedTableView.register(TrendingTableViewCell.self, forCellReuseIdentifier: TrendingTableViewCell.reuseIdentifier)
        view.addSubview(discoverFeedTableView)

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
        // Make network request to get top shows, movies, and playing shows
        super.viewDidAppear(animated)
        print("Get top rated shows")
        NetworkManager.discoverShows { [weak self] mediaList in
            print(mediaList)
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.discoverShows[0] = mediaList.trendingTvs
                self.discoverShows[1] = mediaList.trendingMovies
                self.discoverShows[2] = mediaList.trendingAnimes
                // TODO: Do we want to shuffle this?
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

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.reuseIdentifier, for: indexPath) as? TrendingTableViewCell else { return UITableViewCell() }
        cell.configure(with: discoverShows[indexPath.section])
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return discoverShows.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
    func persentInfoAlert(message: String) {
        persentInfoAlert(message: message, completion: nil)
    }
    
    func showMediaViewController(id: Int) {
        let mediaViewController = MediaViewController(mediaId: id)
        navigationController?.pushViewController(mediaViewController, animated: true)
    }
}
