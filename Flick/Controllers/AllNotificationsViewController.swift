//
//  NotificationsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import SnapKit
import UIKit

class AllNotificationsViewController: UIViewController {

    // MARK: - Private View Vars
    private var backgroundView: UIView!
    private var tabCollectionView: UICollectionView!
    private var tabContainerView: UIView!
    private var tabPageViewController: NotificationsTabPageViewController!

    // MARK: - Private Data Vars
    private var activeTabIndex = 0
    private let tabCellReuseIdentifier = "tabCellReuseIdentifier"
    private let tabs = ["Notifications", "Suggestions"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupNavigationBar()

        backgroundView = UIView()
        backgroundView.backgroundColor = .offWhite
        view.addSubview(backgroundView)

        tabPageViewController = NotificationsTabPageViewController()
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
        // TODO: Fix tab bar shadows
        tabCollectionView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        tabCollectionView.layer.shadowOffset = CGSize(width: 4.0, height: 8.0)
        tabCollectionView.layer.shadowOpacity = 0.07
        tabCollectionView.layer.shadowRadius = 4.0
        view.addSubview(tabCollectionView)

        setUpConstraints()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.navigationBar.barTintColor = .movieWhite
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

    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func setUpConstraints() {

        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(28)
        }

        backgroundView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(tabCollectionView)
        }

        tabContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tabCollectionView.snp.bottom)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tabCellReuseIdentifier, for: indexPath) as? NotificationsTabOptionCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.item == activeTabIndex {
            cell.isSelected = true
        }
        cell.configure(with: tabs[indexPath.item])
        return cell
    }
}

extension AllNotificationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2, height: 28)
    }
}



