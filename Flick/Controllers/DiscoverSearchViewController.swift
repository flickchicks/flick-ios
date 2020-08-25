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

        title = "Search"
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
        searchResultPageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: searchResultPageReuseIdentifier)
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

        navigationItem.titleView = searchBar
//        searchBar.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(50)
//            make.trailing.equalToSuperview().inset(20)
//            make.height.equalTo(36)
//        }
    }

    private func setupConstraints() {
        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }

        searchResultPageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tabCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func setupViewControllers() {
        tabs.forEach { tab in
            searchResultViewControllers.append(SearchResultViewController(seachTab: tab))
        }
    }

    func setCurrentPosition(position: Int){
        currentPosition = position
        let path = IndexPath(item: currentPosition, section: 0)

        DispatchQueue.main.async {
//            if self.tabStyle == .flexible {
//                self.collectionHeader.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
//            }

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
        if collectionView == tabCollectionView {
            return tabs.count
        } else {
            return searchResultViewControllers.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchTabCellReuseIdentifier, for: indexPath) as? SearchTabCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: tabs[indexPath.item].rawValue)
            if indexPath.item == currentPosition {
                cell.isSelected = true
//                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchResultPageReuseIdentifier, for: indexPath)
            let vc = searchResultViewControllers[indexPath.item]
            cell.addSubview(vc.view)
            vc.view.snp.makeConstraints { make in
                make.edges.equalTo(cell)
            }
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
