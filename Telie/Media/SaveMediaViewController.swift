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

enum MediaListsModalViewType {
    case saveMedia, moveMedia
}

class SaveMediaViewController: UIViewController {

    // MARK: - Private View Vars
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let listsTableView = UITableView(frame: .zero)
    private let saveListButton = UIButton()
    private let newListButton = UIButton()
    private let newListSpinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    weak var editListDelegate: EditListDelegate?
    private var lists: [SimpleMediaList] = []
    private let mediaId: Int
    private var selectedLists: [Bool] = []

    init(mediaId: Int) {
        self.mediaId = mediaId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

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
        listsTableView.separatorStyle = .none
        listsTableView.estimatedSectionHeaderHeight = 0
        listsTableView.showsVerticalScrollIndicator = false
        view.addSubview(listsTableView)

        saveListButton.setTitle("Save", for: .normal)
        saveListButton.setTitleColor(.gradientPurple, for: .normal)
        saveListButton.titleLabel?.font = .systemFont(ofSize: 14)
        saveListButton.addTarget(self, action: #selector(saveListButtonPressed), for: .touchUpInside)
        view.addSubview(saveListButton)

        newListButton.setTitle("New", for: .normal)
        newListButton.setTitleColor(.gradientPurple, for: .normal)
        newListButton.titleLabel?.font = .systemFont(ofSize: 14)
        newListButton.addTarget(self, action: #selector(newListButtonPressed), for: .touchUpInside)
        view.addSubview(newListButton)

        view.addSubview(newListSpinner)
        view.addSubview(spinner)

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
            make.leading.equalToSuperview().offset(4)
            make.size.equalTo(CGSize(width: 66, height: 34))
        }

        saveListButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(4)
            make.size.equalTo(CGSize(width: 66, height: 34))
        }

        newListSpinner.snp.makeConstraints { make in
            make.center.equalTo(saveListButton)
        }

    }

    private func getLists() {
        listsTableView.isHidden = true
        spinner.startAnimating()
        NetworkManager.getUserProfile { [weak self] user in
            guard let self = self, let user = user else { return }
            DispatchQueue.main.async {
                let lists = (user.ownerLsts ?? []) + (user.collabLsts ?? [])
                self.lists = lists
                self.spinner.stopAnimating()
                self.listsTableView.isHidden = false
                self.selectedLists = lists.map { _ in return false}
                self.listsTableView.reloadData()
                self.spinner.stopAnimating()
            }
        }
    }

    @objc func saveListButtonPressed() {
        var lstsIds: [Int] = []
        for (index, selected) in selectedLists.enumerated() {
            if selected {
                lstsIds.append(lists[index].id)
            }
        }
        guard lstsIds.count > 0 else {
            dismiss(animated: true)
            return
        }
        newListSpinner.startAnimating()
        self.saveListButton.isHidden = true
        NetworkManager.addToLists(mediaId: mediaId, listIds: lstsIds) { [weak self] success in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.newListSpinner.stopAnimating()
                self.saveListButton.isHidden = false
                self.showSaveMessage(message: "Saved to lists")
            }
        }
    }

    @objc func newListButtonPressed() {
        presentCreateNewList()
    }

    func showSaveMessage(message: String) {
        dismiss(animated: true) {
            let banner = StatusBarNotificationBanner(
                title: message,
                style: .info,
                colors: CustomBannerColors()
            )
            banner.show()
        }
    }
}

extension SaveMediaViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.item
        guard index <= selectedLists.count else { return }
        selectedLists[index].toggle()
        listsTableView.reloadData()
    }

}

extension SaveMediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveToListTableViewCell.reuseIdentifier, for: indexPath) as? SaveToListTableViewCell else { return UITableViewCell() }
        let index = indexPath.item
        cell.configure(
            for: lists[index],
            isSelected: selectedLists[index],
            index: index,
            delegate: self
        )
        return cell
    }
}

extension SaveMediaViewController: SaveMediaDelegate {

    func saveMedia(selectedList: SimpleMediaList) {
        newListSpinner.startAnimating()
        saveListButton.isHidden = true
        NetworkManager.addToMediaList(listId: selectedList.id, mediaIds: [mediaId]) { [weak self] list in
            guard let self = self else { return }
            self.newListSpinner.stopAnimating()
            self.saveListButton.isHidden = false
            self.showSaveMessage(message: "Saved to \(list.name)")
        }
    }

    func selectMedia(selectedIndex: Int) {
        guard selectedIndex <= selectedLists.count else { return }
        selectedLists[selectedIndex].toggle()
        listsTableView.reloadData()
    }

    func presentCreateNewList() {
        let nameViewController = NameViewController(type: .createList)
        nameViewController.createListDelegate = self
        present(nameViewController, animated: true)
    }

}

extension SaveMediaViewController: CreateListDelegate {
    func createList(list: MediaList) {
        getLists()
    }
}
