//
//  SearchForReactionViewController.swift
//  Telie
//
//  Created by Haiying W on 3/5/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

protocol MediaForReactionDelegate: AnyObject {
    func selectMediaForReaction(media: Media)
}

class SearchForReactionViewController: UIViewController {

    // MARK: - Private View Vars
    private let emptyStateView = EmptyStateView(type: .search)
    private let searchBar = SearchBar()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let resultsTableView = UITableView()

    // MARK: - Data Vars
    private var results = [Media]()
    private let searchResultCellReuseIdentifier = "SearchResultCellReuseIdentifier"
    private var timer: Timer?
    weak var delegate: MediaForReactionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select Title"
        view.backgroundColor = .offWhite

        searchBar.placeholder = "Search movies and shows"
        searchBar.delegate = self
        view.addSubview(searchBar)

        resultsTableView.backgroundColor = .offWhite
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.register(DiscoverSearchResultTableViewCell.self, forCellReuseIdentifier: searchResultCellReuseIdentifier)
        resultsTableView.showsVerticalScrollIndicator = false
        resultsTableView.separatorStyle = .none
        resultsTableView.keyboardDismissMode = .onDrag
        view.addSubview(resultsTableView)

        view.addSubview(spinner)

        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    func setupConstraints() {
        emptyStateView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(20)
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        resultsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false

        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowOpacity = 0.0
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func getSearchResult(timer: Timer) {
        if let userInfo = timer.userInfo as? [String: String],
            let searchText = userInfo["searchText"] {
            emptyStateView.isHidden = true
            if searchText == "" {
                results.removeAll()
                resultsTableView.reloadData()
                spinner.stopAnimating()
                return
            }

            if results.count == 0 {
                spinner.startAnimating()
            }

            NetworkManager.searchMedia(query: searchText) { [weak self] (query, media) in
                guard let self = self else { return }
                // Update search result only if there's no query or query matches current searchText
                if let query = query, query != self.searchBar.searchTextField.text {
                    return
                }
                DispatchQueue.main.async {
                    self.emptyStateView.isHidden = !media.isEmpty
                    self.results = media
                    self.spinner.stopAnimating()
                    self.resultsTableView.reloadData()
                }
            }
        }
    }

}

extension SearchForReactionViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCellReuseIdentifier, for: indexPath) as? DiscoverSearchResultTableViewCell else { return UITableViewCell() }
        cell.configureMedia(media: results[indexPath.item])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectMediaForReaction(media: results[indexPath.row])
        navigationController?.popViewController(animated: true)
    }

}

extension SearchForReactionViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: 0.2,
            target: self,
            selector: #selector(getSearchResult),
            userInfo: ["searchText": searchText],
            repeats: false
        )
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

