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
    private var searchResultViewControllers = [DiscoverSearchResultViewController]()
    private let searchTabCellReuseIdentifier = "SearchTabCellReuseIdentifier"
    private let tabs: [SearchTab] = [.movies, .shows, .people, .lists]
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .offWhite

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
//       TODO: Revisit using isPagingEnabled
//        searchResultPageCollectionView.isPagingEnabled = true
        searchResultPageCollectionView.isScrollEnabled = false
        view.addSubview(searchResultPageCollectionView)

        searchBar.becomeFirstResponder()

        setupConstraints()
        setupViewControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .offWhite
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

    @objc private func getSearchResult(timer: Timer) {
        if let userInfo = timer.userInfo as? [String: String],
            let searchText = userInfo["searchText"] {
            searchByText(searchText: searchText)
        }
    }

    private func searchByText(searchText: String) {
        guard let cell = searchResultPageCollectionView.cellForItem(at: IndexPath(item: currentPosition, section: 0)) as? DiscoverSearchVCCollectionViewCell else { return }
        cell.viewController.updateSearchResult(query: searchText)
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
            cell.viewController.delegate = self
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCollectionView {
            setCurrentPosition(position: indexPath.item)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == searchResultPageCollectionView {
            let currentIndex = Int(searchResultPageCollectionView.contentOffset.x / searchResultPageCollectionView.frame.size.width)
            setCurrentPosition(position: currentIndex)
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == searchResultPageCollectionView {
            if let searchText = searchBar.text {
                searchByText(searchText: searchText)
            }
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

extension DiscoverSearchViewController: DiscoverSearchResultDelegate {

    func pushMediaViewController(mediaId: Int, mediaImageUrl: String?) {
        let mediaVC = MediaViewController(mediaId: mediaId, mediaImageUrl: mediaImageUrl)
        navigationController?.pushViewController(mediaVC, animated: true)
    }

    func pushListViewController(listId: Int) {
        let listVC = ListViewController(listId: listId)
        navigationController?.pushViewController(listVC, animated: true)
    }

    func pushProfileViewController(userId: Int) {
        navigationController?.pushViewController(ProfileViewController(isHome: false, userId: userId), animated: true)
    }

}
