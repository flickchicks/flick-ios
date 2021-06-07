//
//  MoveMediaViewController.swift
//  Telie
//
//  Created by Lucy Xu on 4/12/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import NotificationBannerSwift
import NVActivityIndicatorView
import UIKit

class MoveMediaViewController: UIViewController {

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
    weak var editListDelegate: EditListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        titleLabel.text = "Move to list"
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
            make.trailing.equalToSuperview().inset(4)
            make.size.equalTo(CGSize(width: 66, height: 34))
        }

        newListSpinner.snp.makeConstraints { make in
            make.center.equalTo(newListButton)
        }

    }

    private func getLists() {
        listsTableView.isHidden = true
        spinner.startAnimating()
        NetworkManager.getUserProfile { [weak self] user in
            guard let self = self, let user = user else { return }
            DispatchQueue.main.async {
                self.lists = (user.ownerLsts ?? []) + (user.collabLsts ?? [])
                self.spinner.stopAnimating()
                self.listsTableView.isHidden = false
                self.listsTableView.reloadData()
                self.spinner.stopAnimating()
            }
        }
    }

    @objc func newListButtonPressed() {
        presentCreateNewList()
    }

    func showSaveMessage(listName: String) {
        dismiss(animated: true) {
            let banner = StatusBarNotificationBanner(
                title: "Saved to \(listName)",
                style: .info,
                colors: CustomBannerColors()
            )
            banner.show()
        }
    }
}

extension MoveMediaViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = lists[indexPath.item]
        saveMedia(selectedList: list)
    }

}

extension MoveMediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveToListTableViewCell.reuseIdentifier, for: indexPath) as? SaveToListTableViewCell else { return UITableViewCell() }
        cell.configure(for: lists[indexPath.item], delegate: self)
        return cell
    }
}

extension MoveMediaViewController: SaveMediaDelegate {
    func selectMedia(selectedIndex: Int) {
        let selectedList = lists[selectedIndex]
        saveMedia(selectedList: selectedList)
    }


    func saveMedia(selectedList: SimpleMediaList) {
        newListSpinner.startAnimating()
        newListButton.isHidden = true
        dismiss(animated: true) { () in
            self.editListDelegate?.moveMedia(selectedList: selectedList)
        }
    }

    func presentCreateNewList() {
        let nameViewController = NameViewController(type: .createList)
        nameViewController.createListDelegate = self
        present(nameViewController, animated: true)
    }

}

extension MoveMediaViewController: CreateListDelegate {
    func createList(list: MediaList) {
        getLists()
    }
}
