//
//  ListSettingsViewController.swift
//  Flick
//
//  Created by Haiying W on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import NotificationBannerSwift

protocol ListSettingsDelegate: class {
    func deleteList()
    func renameList(to name: String)
    func updatePrivacy(to isPrivate: Bool)
}

enum ListSetting: String {
    case collaboration = "Collaboration"
    case deleteList = "Delete list"
    case privacy = "Privacy"
    case rename = "Rename"
}

class ListSettingsViewController: UIViewController {

    // MARK: - Table View Sections
    private struct Section {
        let type: SectionType
        let header: String?
        var hasFooter: Bool
        var settingItems: [ListSettingsType]
    }

    private enum SectionType {
        case content
        case details
        case visibility
    }

    private enum ListSettingsType {
        case editCollaborators
        case editContent
        case editDescription
        case deleteList
        case privacy
        case rename

        var icon: String {
            switch self {
            case .editCollaborators:
                return "people"
            case .editContent:
                return "moveContent"
            case .editDescription:
                return "quote"
            case .deleteList:
                return "trashCan"
            case .privacy:
                return "largeLock"
            case .rename:
                return "pencil"
            }
        }

        var textColor: UIColor {
            switch self {
            case .deleteList:
                return .flickRed
            default:
                return .darkBlue
            }
        }

        func getDescription(list: MediaList?) -> String? {
            switch self {
            case .privacy:
                return "Currently \(list?.isPrivate ?? true ? "only you" : "anyone") can view"
            default:
                return nil
            }
        }

        func getTitle(list: MediaList?) -> String {
            switch self {
            case .editCollaborators:
                return "Edit collaborators"
            case .editContent:
                return "Edit content"
            case .editDescription:
                return "Edit description"
            case .deleteList:
                return "Delete list"
            case .privacy:
                return "Make \(list?.isPrivate ?? true ? "public" : "private")"
            case .rename:
                return "Rename \"\(list?.name ?? "")\""
            }
        }
    }


    // MARK: - Private View Vars
    private let settingsTableView = UITableView()

    // MARK: - Private Data Vars
    private let currentUserId = UserDefaults.standard.integer(forKey: Constants.UserDefaults.userId)
    private var list: MediaList
//    private let listSettingsCellReuseIdentifier = "ListSettingsCellReuseIdentifier"
    private var sections: [Section] = []

    init(list: MediaList) {
        self.list = list
        super.init(nibName: nil, bundle: nil)

        var visibilitySection = Section(type: .visibility, header: "Visibility", hasFooter: true, settingItems: [])
        let contentSection = Section(type: .content, header: "Content", hasFooter: true, settingItems: [.editContent])
        let detailsSection = Section(type: .details, header: "Details", hasFooter: false, settingItems: [.rename, .editDescription, .deleteList])

        // Show all settings for owner of list and show only collaboration for collaborators
        if list.owner.id == currentUserId {
            if list.isSaved || list.isWatchLater {
                visibilitySection.settingItems = [.privacy]
                visibilitySection.hasFooter = false
                sections = [visibilitySection]
            } else {
                visibilitySection.settingItems = [.privacy, .editCollaborators]
                sections = [visibilitySection, contentSection, detailsSection]
            }
        } else if list.collaborators.contains(where: { $0.id == currentUserId }) {
            visibilitySection.settingItems = [.editCollaborators]
            visibilitySection.hasFooter = false
            sections = [visibilitySection]
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        title = "List Settings"

        settingsTableView.separatorStyle = .none
        settingsTableView.backgroundColor = .offWhite
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(GeneralSettingsTableViewCell.self, forCellReuseIdentifier: GeneralSettingsTableViewCell.reuseIdentifier)
        settingsTableView.bounces = false
        settingsTableView.contentInset = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        view.addSubview(settingsTableView)

        settingsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false

        let backButtonSize = CGSize(width: 22, height: 18)
            
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .offWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.shadowOpacity = 0.0
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

    private func showAddCollaboratorsModal() {
        present(AddCollaboratorViewController(owner: list.owner, collaborators: list.collaborators, list: list), animated: true)
    }

    private func showDeleteConfirmationModal() {
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] action in
            guard let self = self else { return }
            self.deleteList()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel)

        let deleteAlert = UIAlertController(title: "Delete",
             message: "Are you sure you want to delete this list?",
             preferredStyle: .alert)
        deleteAlert.addAction(cancelAction)
        deleteAlert.addAction(deleteAction)

        self.present(deleteAlert, animated: true)
    }

    private func showEditDescription() {
        present(EditDescriptionViewController(list: list), animated: true)
    }

    private func showRenameListModal() {
        let nameViewController = NameViewController(type: .renameList, list: list)
        nameViewController.listSettingsDelegate = self
        present(nameViewController, animated: true)
    }

    func editListContent() {
        let editVC = EditListViewController(list: list)
        navigationController?.pushViewController(editVC, animated: true)
    }

    private func reloadSection(type: SectionType) {
        sections.enumerated().forEach { (index, section) in
            if section.type == type {
                settingsTableView.reloadSections(IndexSet([index]), with: .automatic)
            }
        }
    }

}

extension ListSettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].settingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneralSettingsTableViewCell.reuseIdentifier, for: indexPath) as? GeneralSettingsTableViewCell else { return UITableViewCell() }
        let section = sections[indexPath.section]
        let item = section.settingItems[indexPath.row]
        cell.configure(descriptionText: item.getDescription(list: list), icon: item.icon, textColor: item.textColor, title: item.getTitle(list: list))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
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

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sections[section].hasFooter ? 22 : 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].settingItems[indexPath.row]
        switch item {
        case .editCollaborators:
            showAddCollaboratorsModal()
        case .editContent:
            editListContent()
        case .editDescription:
            showEditDescription()
        case .deleteList:
            showDeleteConfirmationModal()
        case .privacy:
            updatePrivacy(to: !list.isPrivate)
        case .rename:
            showRenameListModal()
        }
    }

}

extension ListSettingsViewController: ListSettingsDelegate {

    func deleteList() {
        NetworkManager.deleteMediaList(listId: list.id) { [weak self] _ in
            guard let self = self else { return }
            let banner = StatusBarNotificationBanner(
                title: "Deleted \(self.list.name)",
                style: .info,
                colors: CustomBannerColors()
            )
            banner.show()
            let controllers = self.navigationController?.viewControllers
            // Controllers are reversed because recent stack is at the end of the list
            for controller in controllers?.reversed() ?? [] {
                if controller is ProfileViewController || controller is TabBarController {
                    self.navigationController?.popToViewController(controller, animated: true)
                    return
                }
            }
        }
    }

    func renameList(to name: String) {
        list.name = name
        reloadSection(type: .details)
        let banner = StatusBarNotificationBanner(
            title: "Renamed to \(name)",
            style: .info,
            colors: CustomBannerColors()
        )
        banner.show()
    }

    func updatePrivacy(to isPrivate: Bool) {
        var updatedList = list
        updatedList.isPrivate = isPrivate
        list.isPrivate = isPrivate
        reloadSection(type: .visibility)
        NetworkManager.updateMediaList(listId: list.id, list: updatedList) { [weak self] list in
            guard let self = self else { return }
            self.list = list
            let banner = StatusBarNotificationBanner(
                title: "Updated to \(list.isPrivate ? "private" : "public")",
                style: .info,
                colors: CustomBannerColors()
            )
            banner.show()
        }
    }

}
