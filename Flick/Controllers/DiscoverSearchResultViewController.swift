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
    private var results = [Media]()
    private let searchResultCellReuseIdentifier = "SearchResultCellReuseIdentifier"

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
                self.results = movies
                self.resultsTableView.reloadData()
            }
        default:
            break
        }
    }
}

extension DiscoverSearchResultViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCellReuseIdentifier, for: indexPath) as? DiscoverSearchResultTableViewCell,
            let searchType = searchType else { return UITableViewCell() }
        let titleText = results[indexPath.row].title
        cell.configure(searchType: searchType, titleText: titleText)
        return cell
    }

}
