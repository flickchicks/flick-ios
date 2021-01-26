//
//  GroupViewController.swift
//  Flick
//
//  Created by Haiying W on 1/25/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    // MARK: - Private View Vars
    private var tabCollectionView: UICollectionView!
    private var tabContainerView: UIView!
    private let tabPageViewController = GroupTabPageViewController()

    // MARK: - Private Data Vars
    private var activeTabIndex = 0
    private let tabBarHeight: CGFloat = 40
    private let tabCellReuseIdentifier = "tabCellReuseIdentifier"
    private let tabs = ["Vote", "Results"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Group name" // TODO: Replace with actual name of group
        view.backgroundColor = .offWhite

        tabPageViewController.tabDelegate = self
        addChild(tabPageViewController)

        tabContainerView = UIView()
        view.addSubview(tabContainerView)
        tabPageViewController.view.frame = tabContainerView.frame
        tabContainerView.addSubview(tabPageViewController.view)

        let tabLayout = UICollectionViewFlowLayout()
        tabLayout.minimumInteritemSpacing = 0

        tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tabLayout)
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(NotificationsTabOptionCollectionViewCell.self, forCellWithReuseIdentifier: tabCellReuseIdentifier)
        tabCollectionView.backgroundColor = .movieWhite
        tabCollectionView.clipsToBounds = false
        tabCollectionView.layer.masksToBounds = false
        tabCollectionView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        tabCollectionView.layer.shadowOpacity = 0.07
        tabCollectionView.layer.shadowOffset = .init(width: 0, height: 4)
        tabCollectionView.layer.shadowRadius = 8
        view.addSubview(tabCollectionView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    private func setupConstraints() {
        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(tabBarHeight)
        }

        tabContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tabCollectionView.snp.bottom)
        }
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)
        let settingsButtonSize = CGSize(width: 22, height: 22)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowOpacity = 0
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

        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(named: "settingsButton"), for: .normal)
        settingsButton.tintColor = .mediumGray
        settingsButton.snp.makeConstraints { make in
            make.size.equalTo(settingsButtonSize)
        }

        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        let settingsBarButtonItem = UIBarButtonItem(customView: settingsButton)
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func settingsButtonPressed() {

    }


}

extension GroupViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tabCellReuseIdentifier, for: indexPath) as? NotificationsTabOptionCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.item == activeTabIndex {
            cell.isSelected = true
        }
        cell.configure(with: tabs[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeTabIndex = indexPath.item
        tabPageViewController.setViewController(to: indexPath.item)
        tabCollectionView.reloadData()
    }

}

extension GroupViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2, height: tabBarHeight)
    }

}

extension GroupViewController: GroupTabDelegate {

    func setActiveIndex(to index: Int) {
        activeTabIndex = index
        tabCollectionView.reloadData()
    }

}
