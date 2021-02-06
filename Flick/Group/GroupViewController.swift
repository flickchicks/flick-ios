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
    private let backButton = UIButton()
    private let settingsButton = UIButton()
    private var tabCollectionView: UICollectionView!
    private var tabContainerView = UIView()
    private var tabPageViewController: GroupTabPageViewController
    private var addMembersModalView: AddMembersModalView!

    // MARK: - Private Data Vars
    private var activeTabIndex = 0
    private var group: Group
    private var shouldAddMembers: Bool
    private let tabBarHeight: CGFloat = 40
    private let tabs = ["Vote", "Results"]

    // shouldAddMembers only true when group is just created
    init(group: Group, shouldAddMembers: Bool = false) {
        self.group = group
        self.tabPageViewController = GroupTabPageViewController(groupId: group.id)
        self.addMembersModalView = AddMembersModalView(group: group)
        self.shouldAddMembers = shouldAddMembers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if shouldAddMembers {
            addMembersModalView.modalDelegate = self
            showModalPopup(view: addMembersModalView)
            shouldAddMembers = false
        }

        title = group.name
        view.backgroundColor = .offWhite

        tabPageViewController.tabDelegate = self
        addChild(tabPageViewController)

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

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        tabPageViewController.voteViewController.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkManager.getGroup(id: group.id) { [weak self] group in
            guard let self = self else { return }
            self.group = group
            self.title = group.name
        }
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

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

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
        let groupSettingsVC = GroupSettingsViewController(group: group)
        groupSettingsVC.delegate = self
        navigationController?.pushViewController(groupSettingsVC, animated: true)
    }

}

extension GroupViewController: UICollectionViewDataSource, UICollectionViewDelegate {

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

extension GroupViewController: GroupSettingsDelegate {

    func viewResults() {
        activeTabIndex = 1
        tabPageViewController.setViewController(to: 1)
        tabCollectionView.reloadData()
    }

}

extension GroupViewController: GroupVoteDelegate {

    func hideNavigationBarItems() {
        backButton.tintColor = .clear
        navigationItem.leftBarButtonItem?.isEnabled = false
        settingsButton.tintColor = .clear
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    func showNavigationBarItems() {
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem?.isEnabled = true
        settingsButton.tintColor = .mediumGray
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

}


extension GroupViewController: ModalDelegate {

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

}
