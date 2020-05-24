//
//  HomeViewController.swift
//  Flick
//
//  Created by Lucy Xu on 5/22/20.
//  Copyright © 2020 flick. All rights reserved.
//

import SnapKit
import UIKit

class HomeViewController: UIViewController {

    // MARK: - Private View Vars
    private var backgroundView: UIView!
    private var tabCollectionView: UICollectionView!
    private var tabContainerView: UIView!
    private var tabPageViewController: TabPageViewController!

    // MARK: - Private Data Vars
    private var activeTabIndex = 0
    private let tabCellReuseIdentifier = "tabCellReuseIdentifier"
    private let tabs = ["Discover", "Profile"]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .colorFromCode(0xFBFBFF)
        navigationController?.navigationBar.isHidden = true

        backgroundView = UIView()
        backgroundView.backgroundColor = .colorFromCode(0xF4F5FF)
        view.addSubview(backgroundView)

        tabPageViewController = TabPageViewController()
        addChild(tabPageViewController)

        tabContainerView = UIView()
        view.addSubview(tabContainerView)
        tabContainerView.addSubview(tabPageViewController.view)

        let tabLayout = UICollectionViewFlowLayout()
        tabLayout.minimumInteritemSpacing = 0

        tabCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tabLayout)
        tabCollectionView.delegate = self
        tabCollectionView.dataSource = self
        tabCollectionView.register(TabOptionCell.self, forCellWithReuseIdentifier: tabCellReuseIdentifier)
        tabCollectionView.backgroundColor = UIColor.colorFromCode(0xFBFBFF)
        tabCollectionView.clipsToBounds = true
        tabCollectionView.layer.masksToBounds = false
        tabCollectionView.layer.cornerRadius = 24
        tabCollectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        tabCollectionView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        tabCollectionView.layer.shadowOffset = CGSize(width: 4.0, height: 8.0)
        tabCollectionView.layer.shadowOpacity = 0.07
        tabCollectionView.layer.shadowRadius = 0.0
        view.addSubview(tabCollectionView)

        setUpConstraints()
    }

    private func setUpConstraints() {

        tabCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }

        backgroundView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(tabCollectionView)
        }

        tabContainerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tabCollectionView.snp.bottom)
        }
    }


}

extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeTabIndex = indexPath.item
        tabPageViewController.setViewController(to: indexPath.item)
        tabCollectionView.reloadData()
    }

}

extension HomeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tabCellReuseIdentifier, for: indexPath) as? TabOptionCell else { return UICollectionViewCell() }
        if indexPath.item == activeTabIndex {
            cell.isSelected = true
        }
        cell.configure(with: tabs[indexPath.item])
        return cell
    }

}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2, height: 60)
    }
}


