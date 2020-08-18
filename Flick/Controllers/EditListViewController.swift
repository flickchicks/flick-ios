//
//  EditListViewController.swift
//  Flick
//
//  Created by Haiying W on 7/17/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol EditListDelegate: class {
    func moveMedia(selectedList: MediaList)
    func removeMediaFromList()
}

class EditListViewController: UIViewController {

    // MARK: - Private View Vars
    private let backButton = UIButton()
    private let backgroundView = UIView()
    private let deselectButton = UIButton()
    private let deselectLabel = UILabel()
    private let removeButton = UIButton()
    private let removeLabel = UILabel()
    private var mediaCollectionView: UICollectionView!
    private let moveButton = UIButton()
    private let moveLabel = UILabel()
    private let roundTopView = RoundTopView(hasShadow: false)
    private let selectAllButton = UIButton()
    private let selectAllLabel = UILabel()

    // MARK: - Private View Data
    private let actionButtonSize = CGSize(width: 36, height: 36)
    private let cellPadding: CGFloat = 20
    private var numSelected = 0
    private var list: MediaList
    private var media = [SimpleMedia]()
    private let mediaCellReuseIdentifier = "MediaCellReuseIdentifier"
    private var selectedMedia = [SimpleMedia]()

    init(list: MediaList) {
        self.list = list
        self.media = list.shows
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationController?.isNavigationBarHidden = true

        backgroundView.backgroundColor = .white
        backgroundView.layer.backgroundColor = UIColor.backgroundOverlay.cgColor
        view.addSubview(backgroundView)

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)

        selectAllButton.setImage(UIImage(named: "selectAll"), for: .normal)
        selectAllButton.layer.cornerRadius = actionButtonSize.width / 2
        selectAllButton.addTarget(self, action: #selector(selectAllTapped), for: .touchUpInside)
        view.addSubview(selectAllButton)

        selectAllLabel.text = "Select all"
        selectAllLabel.textColor = .white
        selectAllLabel.font = .systemFont(ofSize: 10, weight: .medium)
        view.addSubview(selectAllLabel)

        deselectButton.setImage(UIImage(named: "deselect"), for: .normal)
        deselectButton.layer.cornerRadius = actionButtonSize.width / 2
        deselectButton.isEnabled = false
        deselectButton.addTarget(self, action: #selector(deselectTapped), for: .touchUpInside)
        view.addSubview(deselectButton)

        deselectLabel.text = "Deselect"
        deselectLabel.textColor = .white
        deselectLabel.font = .systemFont(ofSize: 10, weight: .medium)
        view.addSubview(deselectLabel)

        removeButton.setImage(UIImage(named: "remove"), for: .normal)
        removeButton.layer.cornerRadius = actionButtonSize.width / 2
        removeButton.isEnabled = false
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)
        view.addSubview(removeButton)

        removeLabel.text = "Remove"
        removeLabel.textColor = .white
        removeLabel.font = .systemFont(ofSize: 10, weight: .medium)
        view.addSubview(removeLabel)

        moveButton.setImage(UIImage(named: "move"), for: .normal)
        moveButton.layer.cornerRadius = actionButtonSize.width / 2
        moveButton.isEnabled = false
        moveButton.addTarget(self, action: #selector(moveTapped), for: .touchUpInside)
        view.addSubview(moveButton)

        moveLabel.text = "Move"
        moveLabel.textColor = .white
        moveLabel.font = .systemFont(ofSize: 10, weight: .medium)
        view.addSubview(moveLabel)

        view.addSubview(roundTopView)

        let mediaCollectionViewLayout = UICollectionViewFlowLayout()
        mediaCollectionViewLayout.minimumInteritemSpacing = cellPadding
        mediaCollectionViewLayout.minimumLineSpacing = cellPadding
        mediaCollectionViewLayout.scrollDirection = .vertical

        mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mediaCollectionViewLayout)
        mediaCollectionView.backgroundColor = .white
        mediaCollectionView.register(MediaSelectableCollectionViewCell.self, forCellWithReuseIdentifier: mediaCellReuseIdentifier)
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
        mediaCollectionView.showsVerticalScrollIndicator = false
        mediaCollectionView.bounces = false
        mediaCollectionView.allowsMultipleSelection = true
        roundTopView.addSubview(mediaCollectionView)

        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.isNavigationBarHidden = false
    }

    private func setupConstraints() {
        let backButtonSize = CGSize(width: 22, height: 18)
        let buttonToButtonSpacing = 24
        let buttonToLabelSpacing = 2
        let topSpacing = 40

        selectAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(deselectButton.snp.leading).offset(-buttonToButtonSpacing)
            make.top.equalToSuperview().offset(topSpacing)
            make.size.equalTo(actionButtonSize)
        }

        selectAllLabel.snp.makeConstraints { make in
            make.centerX.equalTo(selectAllButton.snp.centerX)
            make.top.equalTo(selectAllButton.snp.bottom).offset(2)
        }

        deselectButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.centerX).offset(-buttonToButtonSpacing / 2)
            make.top.equalToSuperview().offset(topSpacing)
            make.size.equalTo(actionButtonSize)
        }

        deselectLabel.snp.makeConstraints { make in
            make.centerX.equalTo(deselectButton.snp.centerX)
            make.top.equalTo(deselectButton.snp.bottom).offset(buttonToLabelSpacing)
        }

        removeButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.centerX).offset(buttonToButtonSpacing / 2)
            make.top.equalToSuperview().offset(topSpacing)
            make.size.equalTo(actionButtonSize)
        }

        removeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(removeButton.snp.centerX)
            make.top.equalTo(removeButton.snp.bottom).offset(buttonToLabelSpacing)
        }

        moveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topSpacing)
            make.size.equalTo(actionButtonSize)
            make.leading.equalTo(removeButton.snp.trailing).offset(buttonToButtonSpacing)
        }

        moveLabel.snp.makeConstraints { make in
            make.centerX.equalTo(moveButton.snp.centerX)
            make.top.equalTo(moveButton.snp.bottom).offset(buttonToLabelSpacing)
        }

        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(50)
        }

        roundTopView.snp.makeConstraints { make in
            make.top.equalTo(selectAllLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }

        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(roundTopView.snp.top).offset(45)
            make.leading.trailing.equalToSuperview().inset(27)
            make.bottom.equalToSuperview()
        }
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func selectAllTapped() {
        for item in 0 ..< media.count {
            let indexPath = IndexPath(item: item, section: 0)
            let cell = mediaCollectionView.cellForItem(at: indexPath)
            mediaCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            cell?.isSelected = true
        }
        setActionsActive(true)
        numSelected = media.count
        selectedMedia = media
    }

    @objc private func deselectTapped() {
        guard let selectedIndexPaths = mediaCollectionView.indexPathsForSelectedItems else { return }
        for indexPath in selectedIndexPaths {
            let cell = mediaCollectionView.cellForItem(at: indexPath)
            mediaCollectionView.deselectItem(at: indexPath, animated: true)
            cell?.isSelected = false
        }
        setActionsActive(false)
        numSelected = 0
        selectedMedia = []
    }

    @objc private func removeTapped() {
        let deleteConfirmationModalView = ConfirmationModalView(message: "Are you sure you want to remove [\(selectedMedia.count)] items from this list?", type: .removeMedia)
        deleteConfirmationModalView.modalDelegate = self
        deleteConfirmationModalView.editListDelegate = self
        showModalPopup(view: deleteConfirmationModalView)
    }

    @objc private func moveTapped() {
        let listsModalView = MediaListsModalView(type: .moveMedia)
        listsModalView.modalDelegate = self
        showModalPopup(view: listsModalView)
    }

    private func setActionsActive(_ isActive: Bool) {
        deselectButton.isEnabled = isActive
        moveButton.isEnabled = isActive
        removeButton.isEnabled = isActive
    }
}

extension EditListViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifier, for: indexPath) as? MediaSelectableCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(media: media[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setActionsActive(true)
        numSelected += 1
        selectedMedia.append(media[indexPath.item])
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        numSelected -= 1
        setActionsActive(numSelected != 0)
        selectedMedia.removeAll { $0.id == media[indexPath.item].id }
    }
}

extension EditListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = mediaCollectionView.frame.width / 3.0 - cellPadding
        let height = width * 3 / 2
        return CGSize(width: width, height: height)
    }

}

extension EditListViewController: ModalDelegate {

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

}

extension EditListViewController: EditListDelegate {

    func moveMedia(selectedList: MediaList) {
        let mediaIds = selectedMedia.map { $0.id }
        NetworkManager.addToMediaList(listId: selectedList.id) { [weak self] list in
            guard let self = self else { return }

            self.persentInfoAlert(message: "Moved \(self.selectedMedia.count) items to \(selectedList.name)", completion: nil)

            self.mediaCollectionView.reloadData()
            self.selectedMedia = []
        }
    }

    func removeMediaFromList() {
        var updatedList = list
        var updatedMedia = media
        updatedMedia = updatedMedia.filter { media -> Bool in
            !selectedMedia.contains { media.id == $0.id }
        }
        updatedList.shows = updatedMedia
        NetworkManager.updateMediaList(listId: list.id, list: updatedList) { [weak self] list in
            guard let self = self else { return }

            self.persentInfoAlert(message: "Removed \(self.selectedMedia.count) items", completion: nil)
            self.list = list
            self.media = list.shows
            self.mediaCollectionView.reloadData()
            self.selectedMedia = []
        }
    }

}
