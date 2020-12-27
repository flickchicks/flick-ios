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

    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        searchBar.placeholder = "Search movies, shows, people, genres"
        searchBar.delegate = self
        view.addSubview(searchBar)

        setupConstraints()
    }

    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(36)
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

