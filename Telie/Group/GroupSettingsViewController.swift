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
        let header: String?
        let hasFooter: Bool
        var settingItems: [GroupSettingsType]
    }

    private enum SectionType {
        case delete
        case details
        case ideas
        case results
    }

    private enum GroupSettingsType {
        case addMembers
        case clearIdeas
        case clearVotes
        case deleteGroup
        case rename
        case viewResults

        var icon: String {
            switch self {
            case .addMembers:
                return "circlePlus"
            case .clearIdeas, .clearVotes:
                return "refresh"
            case .deleteGroup:
                return "trashCan"
            case .rename:
                return "pencil"
            case .viewResults:
                return "medal"
            }
        }

        var textColor: UIColor {
            switch self {
            case .deleteGroup:
                return .flickRed
            default:
                return .darkBlue
            }
        }

        var descriptionText: String? {
            switch self {
            case .clearIdeas:
                return "Remove the active ideas and votes so that you can start again"
            case .clearVotes:
                return "Keep the current ideas but reset votes"
            case .viewResults:
                return "See what the group has decided on so far"
            default:
                return nil
            }
        }

        func getTitle(group: Group?) -> String {
            switch self {
            case .addMembers:
                return "Add members"
            case .clearIdeas:
                return "Clear current ideas"
            case .clearVotes:
                return "Clear current votes"
            case .deleteGroup:
                return "Delete group"
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
        let ideasSection = Section(type: .ideas, header: "Ideas", hasFooter: true, settingItems: [.clearIdeas, .clearVotes])
        let resultsSection = Section(type: .results, header: "Results", hasFooter: true, settingItems: [.viewResults])
        let detailsSection = Section(type: .details, header: "Details", hasFooter: false, settingItems: [.rename, .addMembers])
        let deleteSection = Section(type: .delete, header: nil, hasFooter: false, settingItems: [.deleteGroup])
        sections = [ideasSection, resultsSection, detailsSection, deleteSection]
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
        let clearAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] action in
            guard let self = self else { return }
            self.clearIdeas()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let clearIdeasAlert = UIAlertController(title: "Clear all current ideas and votes?",
             message: "To pick a new show, the group have to start fresh.",
             preferredStyle: .alert)
        clearIdeasAlert.addAction(cancelAction)
        clearIdeasAlert.addAction(clearAction)

        self.present(clearIdeasAlert, animated: true)
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

    private func clearVotes() {
        NetworkManager.clearVotes(id: group.id) { success in
            DispatchQueue.main.async {
                if success {
                    let banner = StatusBarNotificationBanner(
                        title: "Votes cleared",
                        style: .info,
                        colors: CustomBannerColors()
                    )
                    banner.show()
                }
            }
        }
    }

    private func deleteGroup() {
        NetworkManager.deleteGroup(groupId: group.id) { [weak self] success in
            guard let self = self else { return }
            if success {
                let controllers = self.navigationController?.viewControllers
                // Controllers are reversed because recent stack is at the end of the list
                for controller in controllers?.reversed() ?? [] {
                    if controller is TabBarController {
                        self.navigationController?.popToViewController(controller, animated: true)
                        return
                    }
                }
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
            cell.configure(descriptionText: item.descriptionText, icon: item.icon, textColor: item.textColor, title: item.getTitle(group: group))
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
        guard sections[section].header != nil else { return nil }
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
        guard sections[section].hasFooter else { return nil }
        let footerView = UIView()
        let spacerView = UIView()
        spacerView.backgroundColor = .lightGray2
        footerView.addSubview(spacerView)
        spacerView.snp.makeConstraints { make in
            make.height.equalTo(2)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section].type == .details && indexPath.row > 1 {
            return 54
        } else {
            return UITableView.automaticDimension
        }
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
        case .clearIdeas:
            showClearIdeasModal()
        case .clearVotes:
            clearVotes()
        case .deleteGroup:
            deleteGroup()
        case .rename:
            showRenameGroupModal()
        case .viewResults:
            delegate?.viewResults()
            navigationController?.popViewController(animated: true)
        }
    }

}

extension GroupSettingsViewController: RenameGroupDelegate, AddMembersDelegate, ClearIdeasDelegate {

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
        NetworkManager.clearIdeas(id: group.id) { success in
            DispatchQueue.main.async {
                if success {
                    let banner = StatusBarNotificationBanner(
                        title: "Ideas cleared",
                        style: .info,
                        colors: CustomBannerColors()
                    )
                    banner.show()
                }
            }
        }
    }

}
