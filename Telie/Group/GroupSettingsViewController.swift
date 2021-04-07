//
//  GroupSettingsViewController.swift
//  Flick
//
//  Created by Haiying W on 1/27/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit
import NotificationBannerSwift

protocol GroupSettingsDelegate: class {
    func viewResults()
}

class GroupSettingsViewController: UIViewController {

    // MARK: - Table View Sections
    private struct Section {
        let type: SectionType
        let header: String
        let footer: String?
        var settingItems: [GroupSettingsType]
    }

    private enum SectionType {
        case details
        case ideas
        case results
    }

    private enum GroupSettingsType {
        case addMembers
        case clear
        case rename
        case viewResults

        var icon: String {
            switch self {
            case .addMembers:
                return "circlePlus"
            case .clear:
                return "refresh"
            case .rename:
                return "pencil"
            case .viewResults:
                return "medal"
            }
        }

        func getTitle(group: Group?) -> String {
            switch self {
            case .addMembers:
                return "Add members"
            case .clear:
                return "Clear current ideas"
            case .rename:
                return "Rename \"\(group?.name ?? "")\""
            case .viewResults:
                return "View results"
            }
        }
    }

    // MARK: - Private View Vars
    private let settingsTableView = UITableView(frame: .zero, style: .grouped)

    // MARK: - Data Vars
    weak var delegate: GroupSettingsDelegate?
    private var group: Group
    private var sections: [Section] = []

    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group Settings"
        view.backgroundColor = .offWhite

        setupSections()

        settingsTableView.backgroundColor = .offWhite
        settingsTableView.separatorStyle = .none
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(GroupSettingTableViewCell.self, forCellReuseIdentifier: GroupSettingTableViewCell.reuseIdentifier)
        settingsTableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        settingsTableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        view.addSubview(settingsTableView)

        settingsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkManager.getGroup(id: group.id) { group in
            DispatchQueue.main.async {
                self.group = group
                self.reloadDetailsSection()
            }
        }
    }

    private func setupSections() {
        let ideasSection = Section(type: .ideas, header: "Ideas", footer: "This removes the active ideas and votes so that you can start again", settingItems: [.clear])
        let resultsSection = Section(type: .results, header: "Results", footer: "See what the group has decided on so far", settingItems: [.viewResults])
        let detailsSection = Section(type: .details, header: "Details", footer: nil, settingItems: [.rename, .addMembers])
        sections = [ideasSection, resultsSection, detailsSection]
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.07
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationController?.navigationBar.layer.shadowRadius = 8
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    private func showAddMembersModal() {
        let addMembersViewController = AddMembersToGroupsViewController(group: group)
        addMembersViewController.delegate = self
        present(addMembersViewController, animated: true)
    }

    private func showClearIdeasModal() {
        let clearIdeasModalView = ConfirmationModalView(
            message: "Clear all current ideas and votes?",
            subMessage: "To pick a new show, the group have to start fresh",
            type: .clearIdeas
        )
        clearIdeasModalView.modalDelegate = self
        clearIdeasModalView.clearIdeasDelegate = self
        showModalPopup(view: clearIdeasModalView)
    }

    private func showRenameGroupModal() {
        let newGroupViewController = NewListViewController(type: .renameGroup)
        newGroupViewController.renameGroupDelegate = self
        newGroupViewController.group = group
        present(newGroupViewController, animated: true)
    }

    private func reloadDetailsSection() {
        sections.enumerated().forEach { (index, section) in
            if section.type == .details {
                settingsTableView.reloadSections(IndexSet([index]), with: .automatic)
            }
        }
    }

}

extension GroupSettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .details:
            return section.settingItems.count + (group.members?.count ?? 0)
        default:
            return section.settingItems.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        if indexPath.row < section.settingItems.count {
            // Setup cell for settings action item
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupSettingTableViewCell.reuseIdentifier, for: indexPath) as? GroupSettingTableViewCell else { return UITableViewCell() }
            let item = section.settingItems[indexPath.row]
            cell.configure(icon: item.icon, title: item.getTitle(group: group))
            return cell
        } else {
            // Setup cell for group member
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell,
                  let members = group.members else { return UITableViewCell() }
            let member = members[indexPath.row - section.settingItems.count]
            cell.configure(user: member)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        headerLabel.text = sections[section].header
        headerLabel.textColor = .darkBlueGray2
        headerLabel.font = .boldSystemFont(ofSize: 14)
        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview().inset(6)
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard sections[section].footer != nil else { return nil }
        let padding = 20
        let footerView = UIView()
        let footerLabel = UILabel()
        let spacerView = UIView()
        footerLabel.text = sections[section].footer
        footerLabel.textColor = .mediumGray
        footerLabel.font = .systemFont(ofSize: 14)
        footerLabel.numberOfLines = 0
        footerView.addSubview(footerLabel)
        footerLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalToSuperview().offset(6)
        }
        spacerView.backgroundColor = .lightGray2
        footerView.addSubview(spacerView)
        spacerView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(footerLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(10)
        }
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Don't do anything if selecting on a group member
        if sections[indexPath.section].type == .details && indexPath.row > 1 {
            return
        }
        let item = sections[indexPath.section].settingItems[indexPath.row]
        switch item {
        case .addMembers:
            showAddMembersModal()
        case .clear:
            showClearIdeasModal()
        case .rename:
            showRenameGroupModal()
        case .viewResults:
            delegate?.viewResults()
            navigationController?.popViewController(animated: true)
        }
    }

}

extension GroupSettingsViewController: ModalDelegate, RenameGroupDelegate, AddMembersDelegate, ClearIdeasDelegate {

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

    func renameGroup(group: Group) {
        self.group = group
        self.reloadDetailsSection()
    }

    func reloadGroupMembers(group: Group) {
        DispatchQueue.main.async {
            self.group = group
            self.reloadDetailsSection()
        }
    }

    func clearIdeas() {
        NetworkManager.clearIdeas(id: group.id) { [weak self] group in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.group = group
                let banner = StatusBarNotificationBanner(
                    title: "Ideas cleared",
                    style: .info
                )
                banner.show()
            }
        }
    }

}
