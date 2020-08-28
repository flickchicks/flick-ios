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
    private var searchType: SearchTab
    private let searchResultCellReuseIdentifier = "SearchResultCellReuseIdentifier"


    let nameLabel = UILabel()

    init(seachTab: SearchTab) {
        self.searchType = seachTab
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

//        nameLabel.text = searchType.rawValue
//        view.addSubview(nameLabel)

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

//        nameLabel.snp.makeConstraints { make in
//            make.centerX.centerY.equalToSuperview()
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        switch searchType {
        case .movies:
            break
//            NetworkManager.searchMovies(query: "Frozen") { [weak self] movies in
//                guard let self = self else { return }
//                self.results = movies
//                print(self.results)
//                print(self.results[0].title)
//            }
        case .shows:
            break
//            NetworkManager.searchShows(query: "Friends") { [weak self] shows in
//                guard let self = self else { return }
//                self.results = shows
//                print(self.results)
//                print(self.results[0].title)
//            }
        default:
            break
        }
    }

}

extension DiscoverSearchResultViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: searchResultCellReuseIdentifier, for: indexPath) as? DiscoverSearchResultTableViewCell else { return UITableViewCell() }
        return cell
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }

}
