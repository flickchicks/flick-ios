//
//  GroupsViewController.swift
//  Flick
//
//  Created by Haiying W on 2/5/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class GroupsViewController: UIViewController {

    // MARK: - Private View Vars
    private let createGroupButton = UIButton()
    private let emptyStateView = EmptyStateView(type: .group)
    private let groupsTableView = UITableView(frame: .zero, style: .grouped)
    private let refreshControl = UIRefreshControl()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 30, height: 30),
        type: .ballSpinFadeLoader,
        color: .gradientPurple
    )

    // MARK: - Private View Vars
    private var groups: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        groupsTableView.backgroundColor = .offWhite
        groupsTableView.dataSource = self
        groupsTableView.delegate = self
        groupsTableView.separatorStyle = .none
        groupsTableView.showsVerticalScrollIndicator = false
        groupsTableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.reuseIdentifier)
        groupsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        view.addSubview(groupsTableView)

        createGroupButton.setTitle("＋ Create Group", for: .normal)
        createGroupButton.setTitleColor(.gradientPurple, for: .normal)
        createGroupButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        createGroupButton.backgroundColor = .lightPurple
        createGroupButton.layer.borderWidth = 2
        createGroupButton.layer.borderColor = UIColor.gradientPurple.cgColor
        createGroupButton.layer.cornerRadius = 20
        createGroupButton.addTarget(self, action: #selector(createGroupPressed), for: .touchUpInside)
        view.addSubview(createGroupButton)

        refreshControl.addTarget(self, action: #selector(refreshGroups), for: .valueChanged)
        groupsTableView.refreshControl = refreshControl
        
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)

        view.addSubview(spinner)
        spinner.startAnimating()

        groupsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        createGroupButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            make.size.equalTo(CGSize(width: 134, height: 40))
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(50)
        }

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getGroups()
    }

    @objc private func createGroupPressed() {
        let createGroupModalView = EnterNameModalView(type: .createGroup)
        createGroupModalView.modalDelegate = self
        createGroupModalView.createGroupDelegate = self
        showModalPopup(view: createGroupModalView)
    }

    @objc private func refreshGroups() {
        getGroups()
    }

    private func getGroups() {
        NetworkManager.getGroups { [weak self] groups in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.groups = groups
                self.emptyStateView.isHidden = groups.count > 0
                self.groupsTableView.reloadData()
                self.refreshControl.endRefreshing()
                self.spinner.stopAnimating()
            }
        }
    }

}

extension GroupsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.reuseIdentifier, for: indexPath) as? GroupTableViewCell else { return UITableViewCell() }
        cell.configure(for: groups[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        headerLabel.text = "Your Groups"
        headerLabel.textColor = .darkBlue
        headerLabel.font = .boldSystemFont(ofSize: 20)
        headerLabel.textAlignment = .center
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(36)
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = groups[indexPath.row]
        navigationController?.pushViewController(GroupViewController(group: group), animated: true)
    }

}

extension GroupsViewController: ModalDelegate, CreateGroupDelegate {

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

    func createGroup(title: String) {
        NetworkManager.createGroup(name: title) { [weak self] group in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.groups.append(group)
                self.groupsTableView.reloadData()
                let groupViewController = GroupViewController(group: group, shouldAddMembers: true)
                self.navigationController?.pushViewController(groupViewController, animated: true)
            }
        }
    }

}
