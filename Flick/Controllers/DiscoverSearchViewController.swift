//
//  DiscoverSearchViewController.swift
//  Flick
//
//  Created by Haiying W on 8/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class DiscoverSearchViewController: UIViewController {

    // MARK: - Private View Vars
    private let searchBar = SearchBar()
    private var searchResultPageCollectionView: UICollectionView!
    private var tabCollectionView: UICollectionView!

    // MARK: - Private Data Vars
    private var currentPosition = 0
    private let searchResultPageReuseIdentifier = "SearchResultPageCollectionView"
    private var searchResultViewControllers = [UIViewController]()
    private let searchTabCellReuseIdentifier = "SearchTabCellReuseIdentifier"
    private let tabs: [SearchTab] = [.top, .movies, .shows, .people, .tags, .lists]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .offWhite

        setupNavigationBar()

        let tabCollectionViewLayout = UICollectionViewFlowLayout()
        tabCollectionViewLayout.scrollDirection = .horizontal

        tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tabCollectionViewLayout)
        tabCollectionView.backgroundColor = .offWhite
        tabCollectionView.register(SearchTabCollectionViewCell.self, forCellWithReuseIdentifier: searchTabCellReuseIdentifier)
        tabCollectionView.dataSource = self
        tabCollectionView.delegate = self
        tabCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(tabCollectionView)

        let pageCollectionViewLayout = UICollectionViewFlowLayout()
        pageCollectionViewLayout.scrollDirection = .horizontal

        searchResultPageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: pageCollectionViewLayout)
        searchResultPageCollectionView.backgroundColor = .offWhite
        searchResultPageCollectionView.register(DiscoverSearchVCCollectionViewCell.self, forCellWithReuseIdentifier: searchResultPageReuseIdentifier)
        searchResultPageCollectionView.dataSource = self
        searchResultPageCollectionView.delegate = self
        searchResultPageCollectionView.showsHorizontalScrollIndicator = false
        searchResultPageCollectionView.isPagingEnabled = true
        view.addSubview(searchResultPageCollectionView)

        setupConstraints()
        setupViewControllers()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .offWhite
        navigationController?.navigationBar.shadowImage = UIImage()

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    private func setupConstraints() {
        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }

        searchResultPageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tabCollectionView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func setupViewControllers() {
        tabs.forEach { tab in
            let discoverSearchResultVC = DiscoverSearchResultViewController()
            discoverSearchResultVC.searchType = tab
            searchResultViewControllers.append(discoverSearchResultVC)
        }
    }

    func setCurrentPosition(position: Int){
        currentPosition = position
        let path = IndexPath(item: currentPosition, section: 0)

        DispatchQueue.main.async {
            self.tabCollectionView.reloadData()
        }

        DispatchQueue.main.async {
            self.searchResultPageCollectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
        }
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

extension DiscoverSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == tabCollectionView ? tabs.count : searchResultViewControllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchTabCellReuseIdentifier, for: indexPath) as? SearchTabCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: tabs[indexPath.item].rawValue)
            if indexPath.item == currentPosition {
                cell.isSelected = true
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchResultPageReuseIdentifier, for: indexPath) as? DiscoverSearchVCCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(searchType: tabs[indexPath.item])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setCurrentPosition(position: indexPath.row)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == searchResultPageCollectionView {
            let currentIndex = Int(searchResultPageCollectionView.contentOffset.x / searchResultPageCollectionView.frame.size.width)
            setCurrentPosition(position: currentIndex)
        }
    }

}

extension DiscoverSearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabCollectionView {
            let width = collectionView.frame.width / CGFloat(tabs.count) - 10
            return CGSize(width: width, height: 40)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }

}

extension DiscoverSearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let cell = searchResultPageCollectionView.cellForItem(at: IndexPath(item: currentPosition, section: 0)) as? DiscoverSearchVCCollectionViewCell else { return }
        cell.viewController.updateSearchResult(query: searchText)
    }

}
