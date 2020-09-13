//
//  DiscoverSearchResultViewController.swift
//  Flick
//
//  Created by Haiying W on 8/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class DiscoverSearchResultViewController: UIViewController {

    // MARK: - Private View Vars
    private let resultsTableView = UITableView()

    // MARK: - Private Data Vars
    private var lists = [MediaList]()
    private var media = [Media]()
    private let searchResultCellReuseIdentifier = "SearchResultCellReuseIdentifier"
    private var tags = [Tag]()
    private var users = [UserProfile]()

    // MARK: - Public Data Vars
    var searchType: SearchTab?

    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTableView.backgroundColor = .offWhite
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.register(DiscoverSearchResultTableViewCell.self, forCellReuseIdentifier: searchResultCellReuseIdentifier)
        resultsTableView.showsVerticalScrollIndicator = false
        resultsTableView.separatorStyle = .none
        resultsTableView.isDirectionalLockEnabled = true
        view.addSubview(resultsTableView)

        resultsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func updateSearchResult(query: String) {
        switch searchType {
        case .movies:
            NetworkManager.searchMovies(query: query) { [weak self] movies in
                guard let self = self else { return }
                self.media = movies
                self.resultsTableView.reloadData()
            }
        case .shows:
            NetworkManager.searchShows(query: query) { [weak self] shows in
                guard let self = self else { return }
                self.media = shows
                self.resultsTableView.reloadData()
            }
        case .people:
            NetworkManager.searchUsers(query: query) { [weak self] users in
                guard let self = self else { return }
                self.users = users
                self.resultsTableView.reloadData()
            }
        case .tags:
            NetworkManager.searchTags(query: query) { [weak self] tags in
                guard let self = self else { return }
                self.tags = tags
                self.resultsTableView.reloadData()
            }
        case .lists:
            NetworkManager.searchLists(query: query) { [weak self] lists in
                guard let self = self else { return }
                self.lists = lists
                self.resultsTableView.reloadData()
            }
        default:
            break
        }
    }

    func clearContent() {
        lists.removeAll()
        media.removeAll()
        tags.removeAll()
        users.removeAll()
    }
}

extension DiscoverSearchResultViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch searchType {
        case .movies, .shows:
            return media.count
        case .people:
            return users.count
        case .tags:
            return tags.count
        case .lists:
            return lists.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCellReuseIdentifier, for: indexPath) as? DiscoverSearchResultTableViewCell,
            let searchType = searchType else { return UITableViewCell() }
        switch searchType {
        case .movies:
            cell.configureMovie(movie: media[indexPath.item])
        case .shows:
            cell.configureShow(show: media[indexPath.item])
        case .people:
            cell.configureUser(user: users[indexPath.item])
        case .tags:
            cell.configureTag(tag: tags[indexPath.item])
        case .lists:
            cell.configureList(list: lists[indexPath.item])
        default:
            break
        }
        return cell
    }

}
