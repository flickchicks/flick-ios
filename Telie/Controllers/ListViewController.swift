//
//  ListViewController.swift
//  Flick
//
//  Created by HAIYING WENG on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import NotificationBannerSwift
import NVActivityIndicatorView
import UIKit

class ListViewController: UIViewController {

    // MARK: - Collection View Sections
    private struct Section {
        let type: SectionType
        var items: [SimpleMedia]
    }

    private enum SectionType {
        case listSummary
        case mediaList
    }

    // MARK: - Private View Vars
    private let addMediaMessageLabel = UILabel()
    private let arrowToAddButtonView = UIImageView()
    private let backButton = UIButton()
    private let emptyListImageView = UIImageView()
    private let listNameLabel = UILabel()
    private var mediaCollectionView: UICollectionView!
    private let settingsButton = UIButton()
    private var sortListModalView: SortListModalView!
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 30, height: 30),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )

    // MARK: - Private Data Vars
    private let cellPadding: CGFloat = 20
    private let currentUserId = UserDefaults.standard.integer(forKey: Constants.UserDefaults.userId)
    private let edgeInsets: CGFloat = 28
    private let listId: Int
    private var listSummaryHeight: CGFloat = 80
    private var list: MediaList?
    private var sections = [Section]()

    private let headerReuseIdentifier = "HeaderReuseIdentifier"
    private let listSummaryCellReuseIdentifier = "ListSummaryCellReuseIdentifier"
    private let mediaCellReuseIdentifiter = "MediaCellReuseIdentifier"

    init(listId: Int) {
        self.listId = listId
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        listNameLabel.textAlignment = .center
        listNameLabel.font = .boldSystemFont(ofSize: 20)
        listNameLabel.numberOfLines = 0
        view.addSubview(listNameLabel)

        let mediaCollectionViewLayout = UICollectionViewFlowLayout()
        mediaCollectionViewLayout.minimumInteritemSpacing = cellPadding
        mediaCollectionViewLayout.minimumLineSpacing = cellPadding
        mediaCollectionViewLayout.scrollDirection = .vertical
        mediaCollectionViewLayout.sectionHeadersPinToVisibleBounds = true
//        mediaCollectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

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

        view.addSubview(spinner)
        spinner.startAnimating()

        setupSections()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        getMediaList()
    }

    private func getMediaList() {
        NetworkManager.getMediaList(listId: listId) { [weak self] list in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.list = list
                self.listNameLabel.text = list.name
                // Set list summary height only if tags are not expanded
                // TODO: Uncomment when we want tags back
    //            if self.listSummaryHeight <= 145 {
    //                self.listSummaryHeight = list.tags.isEmpty ? 80 : 145
    //            }
                self.setupSections()
                self.mediaCollectionView.reloadData()
                self.spinner.stopAnimating()

                // Show settings button and set up empty state only if current user is owner or collaborator of list
                guard list.owner.id == self.currentUserId ||
                        list.collaborators.contains(where: { $0.id == self.currentUserId }) else  { return }

                self.setupSettingsButton()

                if list.shows.isEmpty {
                    self.setupEmptyStateViews()
                    return
                }

                // Hide empty state views
                self.emptyListImageView.isHidden = true
                self.addMediaMessageLabel.isHidden = true
                self.arrowToAddButtonView.isHidden = true
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupEmptyStateViews() {
        emptyListImageView.image = UIImage(named: "emptyList")
        view.addSubview(emptyListImageView)

        addMediaMessageLabel.text = "Nothing here yet. Add\nsome movies or shows!"
        addMediaMessageLabel.textColor = .darkBlue
        addMediaMessageLabel.textAlignment = .center
        addMediaMessageLabel.font = .systemFont(ofSize: 18, weight: .medium)
        addMediaMessageLabel.numberOfLines = 0
        view.addSubview(addMediaMessageLabel)

        arrowToAddButtonView.image = UIImage(named: "arrowToButton")
        view.addSubview(arrowToAddButtonView)

        setupEmptyStateConstraints()
    }

    private func setupConstraints() {
        listNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(listNameLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupEmptyStateConstraints() {
        let arrowSize = CGSize(width: 30, height: 80)
        let emptyListWidth = UIScreen.main.bounds.width - 2 * edgeInsets
        let emptyListHeight = 1.8 * emptyListWidth
        let emptyListSize = CGSize(width: emptyListWidth, height: emptyListHeight)

        addMediaMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(arrowToAddButtonView.snp.bottom)
            make.trailing.equalTo(arrowToAddButtonView.snp.leading)
        }

        arrowToAddButtonView.snp.makeConstraints { make in
            make.top.equalTo(mediaCollectionView.snp.top).offset(120)
            make.trailing.equalToSuperview().inset(40)
            make.size.equalTo(arrowSize)
        }

        emptyListImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mediaCollectionView.snp.top).offset(140)
            make.size.equalTo(emptyListSize)
        }
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .offWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowOpacity = 0.0

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    private func setupSettingsButton() {

        settingsButton.setImage(UIImage(named: "options"), for: .normal)
        settingsButton.tintColor = .mediumGray
        settingsButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 44, height: 44))
        }

        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        let settingsBarButtonItem = UIBarButtonItem(customView: settingsButton)
        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }

    private func setupSections() {
        let listSummary = Section(type: SectionType.listSummary, items: [])
        let mediaList = Section(type: SectionType.mediaList, items: list?.shows ?? [])
        sections = [listSummary, mediaList]
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func settingsButtonPressed() {
        guard let list = list else { return }
        let listSettingsVC = ListSettingsViewController(list: list)
        navigationController?.pushViewController(listSettingsVC, animated: true)
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
            cell.configure(list: list, delegate: self)
            return cell
        case .mediaList:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifiter, for: indexPath) as? MediaInListCollectionViewCell else { return UICollectionViewCell() }
            let media = section.items[indexPath.row]
            cell.configure(media: media)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section.type {
        case .mediaList:
            let media = section.items[indexPath.row]
            let mediaViewController = MediaAllReactionsViewController(mediaId: media.id, mediaName: media.title)
            navigationController?.pushViewController(mediaViewController, animated: true)
        default:
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        switch section.type {
        case .listSummary:
            return UICollectionReusableView()
        case .mediaList:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? MediaListHeaderView else { return UICollectionReusableView() }
            // An user can modify media of this list if is the owner or a collaborator
            let canModifyMedia: Bool = list?.owner.id == currentUserId || list?.collaborators.contains { $0.id == currentUserId } ?? false
            headerView.configure(for: list, canModifyMedia: canModifyMedia)
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
            let description = list?.description ?? ""
            let descriptionHeight = description == "" ? 0 : description.height(forConstrainedWidth: collectionView.frame.width - 60, font: .systemFont(ofSize: 12)) + 5
            return CGSize(width: collectionView.frame.width, height: listSummaryHeight + descriptionHeight)
        case .mediaList:
            let numCellsInRow: CGFloat = 3
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let extraSpace = 2 * edgeInsets + (flowLayout.minimumInteritemSpacing * numCellsInRow)
            let width = (mediaCollectionView.bounds.width - extraSpace) / numCellsInRow
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
        guard let list = list else { return }
        // Hide navigation bar items
        backButton.tintColor = .clear
        navigationItem.leftBarButtonItem?.isEnabled = false
        settingsButton.tintColor = .clear
        navigationItem.rightBarButtonItem?.isEnabled = false

        let addToListVC = AddMediaViewController(
            type: .toList,
            height: Float(mediaCollectionView.frame.height),
            list: list
        )
        addToListVC.delegate = self
        addToListVC.modalPresentationStyle = .overCurrentContext
        present(addToListVC, animated: true, completion: nil)
    }

    func editMedia() {
        guard let list = list else { return }
        let editVC = EditListViewController(list: list)
        navigationController?.pushViewController(editVC, animated: true)
    }

    func likeList() {
        guard let list = list else { return }
        NetworkManager.likeList(listId: list.id) { _ in }
    }

    func sortMedia() {
        sortListModalView = SortListModalView()
        sortListModalView.modalDelegate = self
        // TODO: Sends navigation bar to the back, but gets covered by the main view
        navigationController?.navigationBar.layer.zPosition = -1
        view.addSubview(sortListModalView)
    }

    func dismissModal(modalView: UIView) {
        navigationController?.navigationBar.layer.zPosition = 1
        modalView.removeFromSuperview()
    }

}

extension ListViewController: ListSummaryDelegate {

    func changeListSummaryHeight(height: Int) {
        listSummaryHeight = CGFloat(height)
        mediaCollectionView.reloadData()
    }

    func pushCollaboratorsView() {
        if let owner = list?.owner {
            let users = [owner] + (list?.collaborators ?? [])
            let usersViewController = UsersViewController(isCollaborators: true, users: users, userId: nil, isCurrentUser: false)
            navigationController?.pushViewController(usersViewController, animated: true)
        }
    }

}

extension ListViewController: AddMediaDelegate {

    func addMediaDismissed() {
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem?.isEnabled = true
        settingsButton.tintColor = .mediumGray
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    func reloadMedia() {
        getMediaList()
        let banner = StatusBarNotificationBanner(
            title: "Added items to list",
            style: .info,
            colors: CustomBannerColors()
        )
        banner.show()
    }

}
