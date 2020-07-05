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
    private let bottomLine = CALayer()
    private let listNameTextField = UITextField()
    private var mediaCollectionView: UICollectionView!
    private var settingsModalView = ListSettingsModalView()
    private var sortListModalView: SortListModalView!

    // MARK: - Private Data Vars
    private var addCollaboratorModalView: AddCollaboratorModalView!
    private let cellPadding: CGFloat = 20
    private let edgeInsets: CGFloat = 28
    private let listNameHeight: CGFloat = 30
    private let listNameWidth: CGFloat = 250
    private var listSummaryHeight: CGFloat = 145
    // TODO: Replace with data from backend
    private let listName = "Foreign Films"
    private let media = ["", "", "", "", "", "", "", "", "", "", "", "", ""]
    private var sections = [Section]()

    private let headerReuseIdentifier = "HeaderReuseIdentifier"
    private let listSummaryCellReuseIdentifier = "ListSummaryCellReuseIdentifier"
    private let mediaCellReuseIdentifiter = "MediaCellReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .offWhite
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        setupNavigationBarForList()

        listNameTextField.text = listName
        listNameTextField.textAlignment = .center
        listNameTextField.font = .boldSystemFont(ofSize: 20)
        listNameTextField.isUserInteractionEnabled = false
        listNameTextField.clearButtonMode = .whileEditing
        listNameTextField.adjustsFontSizeToFitWidth = true
        listNameTextField.minimumFontSize = 12
        view.addSubview(listNameTextField)

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

        setupSections()
        setupConstraints()

        // Add bottom border to text field
        bottomLine.frame = CGRect(x: 0.0, y: listNameHeight - 1, width: listNameWidth, height: 1.0)
        bottomLine.backgroundColor = UIColor.mediumGray.cgColor
        listNameTextField.borderStyle = .none
    }

    private func setupConstraints() {
        listNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(listNameHeight)
            make.width.equalTo(listNameWidth)
        }

        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(listNameTextField.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupNavigationBarForList() {
        let backButtonSize = CGSize(width: 22, height: 18)
        let settingsButtonSize = CGSize(width: 22, height: 22)

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

        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        let settingsBarButtonItem = UIBarButtonItem(customView: settingsButton)
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
    private func setupNavigationBarForSettings() {
        let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }

    private func setupSections() {
        let listSummary = Section(type: SectionType.listSummary, items: [])
        let mediaList = Section(type: SectionType.mediaList, items: media)
        sections = [listSummary, mediaList]
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func cancelButtonPressed() {
        dismissSettings()
        // TODO: set name back to initial
    }

    @objc private func doneButtonPressed() {
        dismissSettings()
        // TODO: send changes to backend
    }

    @objc private func settingsButtonPressed() {
        setupNavigationBarForSettings()
        showSettings()
        listNameTextField.isUserInteractionEnabled = true
        listNameTextField.layer.addSublayer(bottomLine)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
   }
    
    private func showSettings() {
        let collectionViewHeight = mediaCollectionView.frame.height
        let collectionViewWidth = mediaCollectionView.frame.width

        settingsModalView.delegate = self
        settingsModalView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: collectionViewWidth, height: collectionViewHeight)
        view.addSubview(settingsModalView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.settingsModalView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - collectionViewHeight, width: collectionViewWidth, height: collectionViewHeight)
        }, completion: nil)
    }

    private func dismissSettings() {
        let collectionViewHeight = mediaCollectionView.frame.height
        let collectionViewWidth = mediaCollectionView.frame.width

        setupNavigationBarForList()
        listNameTextField.isUserInteractionEnabled = false
        bottomLine.removeFromSuperlayer()

        UIView.animate(withDuration: 0.2, animations: {
            self.settingsModalView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: collectionViewWidth, height: collectionViewHeight)
        }) { (completed) in
            self.settingsModalView.removeFromSuperview()
        }
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
            cell.delegate = self
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
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! MediaListHeaderView
            headerView.delegate = self
            return headerView
        }
    }

}

extension ListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = sections[indexPath.section]
        switch section.type {
        case .listSummary:
            return CGSize(width: collectionView.frame.width, height: listSummaryHeight)
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

extension ListViewController: MediaListHeaderDelegate, ModalDelegate {

    func addMedia() {
        let addToListVC = AddToListViewController(height: Float(mediaCollectionView.frame.height))
        addToListVC.modalPresentationStyle = .overCurrentContext
        present(addToListVC, animated: true, completion: nil)
    }

    func editMedia() {
        print("Edit media")
    }

    func sortMedia() {
        sortListModalView = SortListModalView()
        sortListModalView.delegate = self
        // TODO: Sends navigation bar to the back, but gets covered by the main view
        navigationController?.navigationBar.layer.zPosition = -1
        view.addSubview(sortListModalView)
    }

    func dismissModal(modalView: UIView) {
        navigationController?.navigationBar.layer.zPosition = 1
        modalView.removeFromSuperview()
    }

}

extension ListViewController: ListSettingsDelegate {

    func showAddCollaboratorsModal() {
        addCollaboratorModalView = AddCollaboratorModalView()
        addCollaboratorModalView.delegate = self
        navigationController?.navigationBar.layer.zPosition = -1
        view.addSubview(addCollaboratorModalView)
    }

}

extension ListViewController: ListSummaryDelegate {

    func changeListSummaryHeight(height: Int) {
        listSummaryHeight = CGFloat(height)
        mediaCollectionView.reloadData()
    }

}
