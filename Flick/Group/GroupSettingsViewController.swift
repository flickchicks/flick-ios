//
//  GroupSettingsViewController.swift
//  Flick
//
//  Created by Haiying W on 1/27/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class GroupSettingsViewController: UIViewController {

    // MARK: - Table View Sections
    private struct Section {
        let type: SectionType
        let header: String
        let footer: String?
        var settingItems: [GroupSettingsItem]
        var members: [UserProfile]
    }

    private enum SectionType {
        case details
        case results
        case suggestions
    }

    private struct GroupSettingsItem {
        var type: GroupSettingsType
        var icon: String
        var title: String
    }

    private enum GroupSettingsType {
        case addMembers
        case clear
        case rename
        case viewResults
    }

    // MARK: - Private View Vars
    private let groupSettingReuseIdentifier = "GroupSettingReuseIdentifier"
    private let userCellReuseIdentifier = "UserCellReuseIdentifier"
    private let settingsTableView = UITableView(frame: .zero, style: .grouped)

    // MARK: - Private Data Vars
    private var sections: [Section] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Group settings"
        view.backgroundColor = .offWhite

        setupSections()

        settingsTableView.backgroundColor = .offWhite
        settingsTableView.separatorStyle = .none
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(GroupSettingTableViewCell.self, forCellReuseIdentifier: groupSettingReuseIdentifier)
        settingsTableView.register(UserTableViewCell.self, forCellReuseIdentifier: userCellReuseIdentifier)
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

    private func setupSections() {
        let suggestionsItem = GroupSettingsItem(type: .addMembers, icon: "refresh", title: "Clear current suggestions")
        let suggestionsSection = Section(type: .suggestions, header: "Suggestions", footer: "This removes the active suggestions and votes so that you can start again", settingItems: [suggestionsItem], members: [])

        let resultsItem = GroupSettingsItem(type: .viewResults, icon: "medal", title: "View results")
        let resultsSection = Section(type: .results, header: "Results", footer: "See what the group has decided on so far", settingItems: [resultsItem], members: [])

        let renameItem = GroupSettingsItem(type: .rename, icon: "pencil", title: "Rename \"flick chicks\"")
        let addMembersItem = GroupSettingsItem(type: .addMembers, icon: "circlePlus", title: "Add members")
        let detailsSection = Section(type: .results, header: "Details", footer: nil, settingItems: [renameItem, addMembersItem], members: [])

        sections = [suggestionsSection, resultsSection, detailsSection]
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

    private func showRenameGroupModal() {
        let renameGroupModalView = EnterNameModalView(type: .renameGroup)
        renameGroupModalView.modalDelegate = self
        renameGroupModalView.renameGroupDelegate = self
        showModalPopup(view: renameGroupModalView)
    }

    private func showAddMembersModal() {
        let addMembersModalView = AddMembersModalView()
        addMembersModalView.modalDelegate = self
        showModalPopup(view: addMembersModalView)
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
            return section.settingItems.count + section.members.count
        default:
            return section.settingItems.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: groupSettingReuseIdentifier, for: indexPath) as? GroupSettingTableViewCell else { return UITableViewCell() }
        let item = section.settingItems[indexPath.row]
        cell.configure(icon: item.icon, title: item.title)
        return cell
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
        return 52
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Don't do anything if selecting on a group member
        if sections[indexPath.section].type == .details && indexPath.row > 1 {
            return
        }
        let item = sections[indexPath.section].settingItems[indexPath.row]
        switch item.type {
        case .addMembers:
            print("add members")
            showAddMembersModal()
        case .clear:
            print("clear")
        case .rename:
            print("rename")
            showRenameGroupModal()
        case .viewResults:
            print("view results")
        }
    }

}

extension GroupSettingsViewController: ModalDelegate, RenameGroupDelegate {

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

    func renameGroup(title: String) {
        print("Rename group")
    }
}
