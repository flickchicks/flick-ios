//
//  DiscoverSearchResultViewController.swift
//  Flick
//
//  Created by Haiying W on 8/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import NVActivityIndicatorView
import UIKit
import SkeletonView

protocol DiscoverSearchResultDelegate: class {
    func pushListViewController(listId: Int)
    func pushMediaViewController(mediaId: Int, mediaImageUrl: String?)
    func pushProfileViewController(userId: Int)
}

class DiscoverSearchResultViewController: UIViewController {

    // MARK: - Private View Vars
    private let emptyStateView = EmptyStateView(type: .search)
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .ballSpinFadeLoader,
        color: .gradientPurple
    )
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
        
        view.isSkeletonable = true

        resultsTableView.isSkeletonable = true
        resultsTableView.backgroundColor = .offWhite
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.register(DiscoverSearchResultTableViewCell.self, forCellReuseIdentifier: searchResultCellReuseIdentifier)
        resultsTableView.showsVerticalScrollIndicator = false
        resultsTableView.separatorStyle = .none
        resultsTableView.isDirectionalLockEnabled = true
        resultsTableView.keyboardDismissMode = .onDrag
        view.addSubview(resultsTableView)

        view.addSubview(spinner)

        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)
    
        resultsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyStateView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75)
            make.centerX.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4)
        }
    }

    func updateSearchResult(query: String) {
        emptyStateView.isHidden = true
        if query == "" {
            clearContent()
            return
        }
        spinner.startAnimating()
        switch searchType {
        case .movies:
            NetworkManager.searchMovies(query: query) { [weak self] movies in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.emptyStateView.isHidden = !movies.isEmpty
                    self.media = movies
                    self.spinner.stopAnimating()
                    self.resultsTableView.reloadData()
                }
            }
        case .shows:
            NetworkManager.searchShows(query: query) { [weak self] shows in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.emptyStateView.isHidden = !shows.isEmpty
                    self.media = shows
                    self.spinner.stopAnimating()
                    self.resultsTableView.reloadData()
                }
            }
        case .people:
            NetworkManager.searchUsers(query: query) { [weak self] users in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.emptyStateView.isHidden = !users.isEmpty
                    self.users = users
                    self.spinner.stopAnimating()
                    self.resultsTableView.reloadData()
                }
            }
        case .tags:
            NetworkManager.searchTags(query: query) { [weak self] tags in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.emptyStateView.isHidden = !tags.isEmpty
                    self.tags = tags
                    self.spinner.stopAnimating()
                    self.resultsTableView.reloadData()
                }
            }
        case .lists:
            NetworkManager.searchLists(query: query) { [weak self] lists in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.emptyStateView.isHidden = !lists.isEmpty
                    self.lists = lists
                    self.spinner.stopAnimating()
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

extension DiscoverSearchResultViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return searchResultCellReuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

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
