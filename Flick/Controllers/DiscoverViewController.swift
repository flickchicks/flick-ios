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
    private var discoverShows: [DiscoverMedia] = []
    private let discoverFeedTableView = UITableView()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        searchBar.placeholder = "Search movies, shows, people, generes"
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        discoverFeedTableView.dataSource = self
        discoverFeedTableView.delegate = self
        discoverFeedTableView.layer.backgroundColor = UIColor.clear.cgColor
        discoverFeedTableView.showsVerticalScrollIndicator = false
        discoverFeedTableView.separatorStyle = .none
        discoverFeedTableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        discoverFeedTableView.register(TrendingTableViewCell.self, forCellReuseIdentifier: TrendingTableViewCell.reuseIdentifier)
        discoverFeedTableView.allowsSelection = false
        view.addSubview(discoverFeedTableView)
        
        setupConstraints()
    }

    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(36)
        }
        
        discoverFeedTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Make network request to get top shows, movies, and playing shows
        super.viewWillAppear(animated)
        print("Get top rated shows")
        NetworkManager.discoverShows { [weak self] mediaList in
            print(mediaList)
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.discoverShows = mediaList.trendingTvs + mediaList.trendingMovies + mediaList.trendingAnimes
                // TODO: Do we want to shuffle this?
                self.discoverFeedTableView.reloadData()
            }
        }
        
    }
}

extension DiscoverViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchVC = DiscoverSearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
        searchBar.endEditing(true)
    }

}

extension DiscoverViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.reuseIdentifier, for: indexPath) as? TrendingTableViewCell else { return UITableViewCell() }
        cell.configure(with: discoverShows)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Trending"
//    }
//
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") else { return UITableViewHeaderFooterView() }
        headerView.layer.backgroundColor = UIColor.white.cgColor
        headerView.textLabel?.text = "Trending"
        return headerView
    }
    
}
