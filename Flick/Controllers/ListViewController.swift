//
//  ListViewController.swift
//  Flick
//
//  Created by HAIYING WENG on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import SnapKit
import UIKit

class ListViewController: UIViewController {
    
    // MARK: - Collection View Sections
    private struct Section {
        let type: SectionType
        var items: [String] //TODO: Change String to Media
    }

    private enum SectionType {
        case listSummary
        case mediaList
    }

    // MARK: - Private View Vars
    private var mediaCollectionView: UICollectionView!

    // MARK: - Private Data Vars
    private let cellPadding: CGFloat = 20
    private let edgeInsets: CGFloat = 28
    private let headerReuseIdentifier = "HeaderReuseIdentifier"
    private let listName = "Foreign Films"
    private let listSummaryCellReuseIdentifier = "ListSummaryCellReuseIdentifier"
    // TODO: Replace with data from backend
    private let media = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
    private let mediaCellReuseIdentifiter = "MediaCellReuseIdentifier"
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        setupNavigationBar()

        let mediaCollectionViewLayout = UICollectionViewFlowLayout()
        mediaCollectionViewLayout.minimumInteritemSpacing = cellPadding
        mediaCollectionViewLayout.minimumLineSpacing = cellPadding
        mediaCollectionViewLayout.scrollDirection = .vertical
        mediaCollectionViewLayout.sectionHeadersPinToVisibleBounds = true

        mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mediaCollectionViewLayout)
        mediaCollectionView.backgroundColor = .white
        mediaCollectionView.register(ListSummaryCollectionViewCell.self, forCellWithReuseIdentifier: listSummaryCellReuseIdentifier)
        mediaCollectionView.register(MediaInListCollectionViewCell.self, forCellWithReuseIdentifier: mediaCellReuseIdentifiter)
        mediaCollectionView.register(MediaListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
        mediaCollectionView.showsVerticalScrollIndicator = false
        mediaCollectionView.bounces = false
        view.addSubview(mediaCollectionView)

        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }

        setupSections()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)
        let settingsButtonSize = CGSize(width: 22, height: 22)
            
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .offWhite
        navigationController?.navigationBar.shadowImage = UIImage()

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(named: "settingsButton"), for: .normal)
        settingsButton.snp.makeConstraints { make in
            make.size.equalTo(settingsButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        let settingsBarButtonItem = UIBarButtonItem(customView: settingsButton)
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
    private func setupSections() {
        let listSummary = Section(type: SectionType.listSummary, items: [])
        let mediaList = Section(type: SectionType.mediaList, items: media)
        sections = [listSummary, mediaList]
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        title = offset > 40 ? listName : nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
   }

}

extension ListViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .listSummary:
            return 1
        case .mediaList:
            return section.items.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .listSummary:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listSummaryCellReuseIdentifier, for: indexPath) as? ListSummaryCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case .mediaList:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifiter, for: indexPath) as? MediaInListCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        switch section.type {
        case .listSummary:
            return UICollectionReusableView()
        case .mediaList:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
            return headerView
        }
    }

}

extension ListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        switch section.type {
        case .listSummary:
            return CGSize(width: collectionView.frame.width, height: 195)
        case .mediaList:
            let width = (mediaCollectionView.frame.width - 2 * (cellPadding + edgeInsets)) / 3.0
            let height = width * 3 / 2
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let section = sections[section]
        switch section.type {
        case .listSummary:
            return CGSize(width: 0, height: 0)
        case .mediaList:
            return CGSize(width: collectionView.frame.width, height: 80)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = sections[section]
        switch section.type {
        case .listSummary:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .mediaList:
            return UIEdgeInsets(top: 0, left: edgeInsets, bottom: 10, right: edgeInsets)
        }
    }

}
