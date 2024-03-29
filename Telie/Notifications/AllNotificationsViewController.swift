//
//  NotificationsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import SnapKit
import UIKit

protocol NotificationsTabDelegate: class {
    func setActiveIndex(to index: Int)
}

class AllNotificationsViewController: UIViewController {

    // MARK: - Private View Vars
    private var tabCollectionView: UICollectionView!
    private var tabContainerView: UIView!
    private var tabPageViewController: NotificationsTabPageViewController!
    private let topView = UIView()

    // MARK: - Private Data Vars
    private var activeTabIndex = 0
    private let tabBarHeight: CGFloat = 40
    private let tabs = ["Activity", "Suggestions"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        tabPageViewController = NotificationsTabPageViewController()
        tabPageViewController.notificationsTabDelegate = self
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
        tabCollectionView.register(TabOptionCollectionViewCell.self, forCellWithReuseIdentifier: TabOptionCollectionViewCell.reuseIdentifier)
        tabCollectionView.backgroundColor = .movieWhite
        tabCollectionView.clipsToBounds = false
        tabCollectionView.layer.masksToBounds = false
        tabCollectionView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        tabCollectionView.layer.shadowOpacity = 0.07
        tabCollectionView.layer.shadowOffset = .init(width: 0, height: 4)
        tabCollectionView.layer.shadowRadius = 8
        view.addSubview(tabCollectionView)

        topView.backgroundColor = .movieWhite
        view.addSubview(topView)

        setUpConstraints()

        // Set icon badge to 0 when user taps on notifications
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowOpacity = 0.0

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

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func setUpConstraints() {
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabCollectionView.snp.top)
        }

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

}

extension AllNotificationsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeTabIndex = indexPath.item
        tabPageViewController.setViewController(to: indexPath.item)
        tabCollectionView.reloadData()
    }

}

extension AllNotificationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabOptionCollectionViewCell.reuseIdentifier, for: indexPath) as? TabOptionCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.item == activeTabIndex {
            cell.isSelected = true
        }
        cell.configure(with: tabs[indexPath.item])
        return cell
    }
}

extension AllNotificationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2, height: tabBarHeight)
    }
}

extension AllNotificationsViewController: NotificationsTabDelegate {
    func setActiveIndex(to index: Int) {
        activeTabIndex = index
        tabCollectionView.reloadData()
    }
}
