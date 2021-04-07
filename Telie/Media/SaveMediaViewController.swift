//
//  SaveMediaViewController.swift
//  Telie
//
//  Created by Lucy Xu on 3/30/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import NotificationBannerSwift
import NVActivityIndicatorView
import UIKit

class SaveMediaViewController: UIViewController {

    // MARK: - Private View Vars
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let listsTableView = UITableView(frame: .zero)
    private var lists: [SimpleMediaList] = []
    private let newListButton = UIButton()
    private let newListSpinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let mediaId: Int

    init(mediaId: Int) {
        self.mediaId = mediaId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .offWhite

        titleLabel.text = "Save to list"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 14)
        view.addSubview(titleLabel)

        listsTableView.isHidden = true
        listsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 0)
        listsTableView.dataSource = self
        listsTableView.delegate = self
        listsTableView.backgroundColor = .clear
        listsTableView.register(SaveToListTableViewCell.self, forCellReuseIdentifier: SaveToListTableViewCell.reuseIdentifier)
        listsTableView.rowHeight = UITableView.automaticDimension
        listsTableView.separatorStyle = .singleLine
        listsTableView.estimatedSectionHeaderHeight = 0
        listsTableView.showsVerticalScrollIndicator = false
        view.addSubview(listsTableView)

        newListButton.setTitle("Add", for: .normal)
        newListButton.setTitleColor(.gradientPurple, for: .normal)
        newListButton.titleLabel?.font = .systemFont(ofSize: 14)
        newListButton.addTarget(self, action: #selector(newListButtonPressed), for: .touchUpInside)
        view.addSubview(newListButton)

        view.addSubview(newListSpinner)
        view.addSubview(spinner)

        spinner.startAnimating()
        getLists()
        setupConstraints()

    }

    private func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.trailing.equalToSuperview().inset(24)
            make.size.equalTo(CGSize(width: 144, height: 22))
        }

        listsTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.leading.trailing.bottom.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(listsTableView)
        }

        newListButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(4)
            make.size.equalTo(CGSize(width: 66, height: 34))
        }

        newListSpinner.snp.makeConstraints { make in
            make.center.equalTo(newListButton)
        }

    }

    private func getLists() {
        NetworkManager.getUserProfile { [weak self] user in
            guard let self = self, let user = user else { return }
            DispatchQueue.main.async {
                self.lists = (user.ownerLsts ?? []) + (user.collabLsts ?? [])
                self.spinner.stopAnimating()
                self.listsTableView.isHidden = false
                self.listsTableView.reloadData()
            }
        }
    }

    @objc func newListButtonPressed() {
        presentCreateNewList()
    }

    func showSaveMessage(listName: String) {
        dismiss(animated: true) {
            let banner = FloatingNotificationBanner(
                subtitle: "Saved to \(listName)",
                subtitleFont: .boldSystemFont(ofSize: 14),
                subtitleColor: .black,
                subtitleTextAlign: .center,
                style: .info,
                colors: CustomBannerColors()
            )
            banner.show(
                queuePosition: .front,
                bannerPosition: .top,
                queue: .default,
                edgeInsets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12),
                cornerRadius: 20
            )
        }
    }
}

extension SaveMediaViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = lists[indexPath.item]
        saveMedia(selectedList: list)
    }

}

extension SaveMediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveToListTableViewCell.reuseIdentifier, for: indexPath) as? SaveToListTableViewCell else { return UITableViewCell() }
        cell.configure(for: lists[indexPath.item], delegate: self)
        return cell
    }
}

extension SaveMediaViewController: SaveMediaDelegate {

    func saveMedia(selectedList: SimpleMediaList) {
        newListSpinner.startAnimating()
        newListButton.isHidden = true
        NetworkManager.addToMediaList(listId: selectedList.id, mediaIds: [mediaId]) { [weak self] list in
            guard let self = self else { return }
            self.newListSpinner.stopAnimating()
            self.newListButton.isHidden = false
            self.showSaveMessage(listName: list.name)
        }
    }

    func presentCreateNewList() {
        let createListModal = EnterNameModalView(type: .createList)
        createListModal.modalDelegate = self
        createListModal.createListDelegate = self
        showModalPopup(view: createListModal)
    }

}

extension SaveMediaViewController: ModalDelegate {

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

}

extension SaveMediaViewController: CreateListDelegate {

    func createList(title: String) {
        newListSpinner.startAnimating()
        newListButton.isHidden = true
        NetworkManager.createNewMediaList(listName: title, mediaIds: [mediaId]) { [weak self] mediaList in
            guard let self = self else { return }
            self.newListSpinner.stopAnimating()
            self.newListButton.isHidden = false
            self.showSaveMessage(listName: mediaList.name)
        }
    }

}
