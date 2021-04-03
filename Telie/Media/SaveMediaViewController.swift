//
//  SaveMediaViewController.swift
//  Telie
//
//  Created by Lucy Xu on 3/30/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SaveMediaViewController: UIViewController {

    // MARK: - Private View Vars
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .ballSpinFadeLoader,
        color: .gradientPurple
    )
    private let listsTableView = UITableView(frame: .zero)
    private var lists: [SimpleMediaList] = []
    private let newListButton = NewListButton()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .offWhite

        titleLabel.text = "Save to list"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 14)
        view.addSubview(titleLabel)

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

        view.addSubview(newListButton)
        view.addSubview(spinner)

        spinner.startAnimating()
        getLists()
        setupConstraints()

    }

    private func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
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
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

    }

    private func getLists() {
        NetworkManager.getUserProfile { [weak self] user in
            guard let self = self, let user = user else { return }
            DispatchQueue.main.async {
                self.lists = (user.ownerLsts ?? []) + (user.collabLsts ?? [])
                self.spinner.stopAnimating()
                self.listsTableView.reloadData()
            }
        }
    }
}

extension SaveMediaViewController: UITableViewDelegate {

}

extension SaveMediaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SaveToListTableViewCell.reuseIdentifier, for: indexPath) as? SaveToListTableViewCell else { return UITableViewCell() }
        cell.configure(for: lists[indexPath.item])
        return cell
    }

}
