//
//  DiscoverSearchResultViewController.swift
//  Flick
//
//  Created by Haiying W on 8/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol DiscoverSearchResultDelegate: class {
    func pushListViewController(listId: Int)
    func pushMediaViewController(mediaId: Int, mediaImageUrl: String?)
    func pushProfileViewController(userId: Int)
}

class DiscoverSearchResultViewController: UIViewController {

    // MARK: - Private View Vars
    private let resultsTableView = UITableView()

    // MARK: - Data Vars
    private let currentUserId = UserDefaults.standard.integer(forKey: Constants.UserDefaults.userId)
    weak var delegate: DiscoverSearchResultDelegate?
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
        if query == "" {
            clearContent()
            return
        }
        switch searchType {
        case .movies:
            NetworkManager.searchMovies(query: query) { [weak self] movies in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.media = movies
                    self.resultsTableView.reloadData()
                }
            }
        case .shows:
            NetworkManager.searchShows(query: query) { [weak self] shows in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.media = shows
                    self.resultsTableView.reloadData()
                }
            }
        case .people:
            NetworkManager.searchUsers(query: query) { [weak self] users in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.users = users
                    self.resultsTableView.reloadData()
                }
            }
        case .tags:
            NetworkManager.searchTags(query: query) { [weak self] tags in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tags = tags
                    self.resultsTableView.reloadData()
                }
            }
        case .lists:
            NetworkManager.searchLists(query: query) { [weak self] lists in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.lists = lists
                    self.resultsTableView.reloadData()
                }
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
        resultsTableView.reloadData()
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
            let user = users[indexPath.item]
            cell.configureUser(isCurrentUser: currentUserId == user.id,
                               user: user)
        case .tags:
            cell.configureTag(tag: tags[indexPath.item])
        case .lists:
            cell.configureList(list: lists[indexPath.item])
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchType {
        case .movies, .shows:
            delegate?.pushMediaViewController(mediaId: media[indexPath.row].id, mediaImageUrl: media[indexPath.row].posterPic)
        case .people:
            delegate?.pushProfileViewController(userId: users[indexPath.row].id)
        case .lists:
            delegate?.pushListViewController(listId: lists[indexPath.row].id)
        default:
            break
        }
    }

}
