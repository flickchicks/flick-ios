//
//  ListSettingsViewController.swift
//  Flick
//
//  Created by Haiying W on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol ListSettingsDelegate: class {
    func addCollaborator(collaborator: UserProfile)
    func deleteList()
    func removeCollaborator(collaborator: UserProfile)
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

    // MARK: - Private View Vars
    private var addCollaboratorModalView: AddCollaboratorModalView!
    private let settingsTableView = UITableView()

    // MARK: - Private Data Vars
    private let currentUserId = UserDefaults.standard.integer(forKey: Constants.UserDefaults.userId)
    private var list: MediaList
    private let listSettingsCellReuseIdentifier = "ListSettingsCellReuseIdentifier"
    private var settings = [ListSetting]()

    init(list: MediaList) {
        self.list = list
        super.init(nibName: nil, bundle: nil)

        // Show all settings for owner of list and show only collaboration for collaborators
        if list.owner.id == currentUserId {
            if list.isSaved || list.isWatchLater {
                settings = [.privacy]
            } else {
                settings = [.collaboration, .privacy, .rename, .deleteList]
            }
        } else if list.collaborators.contains(where: { $0.id == currentUserId }) {
            settings = [.collaboration]
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        settingsTableView.separatorStyle = .none
        settingsTableView.backgroundColor = .offWhite
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(ListSettingsTableViewCell.self, forCellReuseIdentifier: listSettingsCellReuseIdentifier)
        settingsTableView.bounces = false
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
        present(AddCollaboratorViewController(owner: list.owner, collaborators: list.collaborators), animated: true)
//        addCollaboratorModalView = AddCollaboratorModalView(owner: list.owner, collaborators: list.collaborators)
//        addCollaboratorModalView.modalDelegate = self
//        addCollaboratorModalView.listSettingsDelegate = self
//        showModalPopup(view: addCollaboratorModalView)
    }

    private func showDeleteConfirmationModal() {
        let deleteConfirmationModalView = ConfirmationModalView(message: "Are you sure you want to delete this list?", type: .deleteList)
        deleteConfirmationModalView.modalDelegate = self
        deleteConfirmationModalView.listSettingsDelegate = self
        showModalPopup(view: deleteConfirmationModalView)
    }

    private func showRenameListModal() {
        let renameListModalView = EnterNameModalView(type: .renameList)
        renameListModalView.modalDelegate = self
        renameListModalView.listSettingsDelegate = self
        showModalPopup(view: renameListModalView)
    }

}

extension ListSettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: listSettingsCellReuseIdentifier, for: indexPath) as? ListSettingsTableViewCell else { return UITableViewCell() }
        cell.configure(for: settings[indexPath.row], list: list, delegate: self)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        switch setting {
        case .collaboration:
            showAddCollaboratorsModal()
        case .deleteList:
            showDeleteConfirmationModal()
        case .rename:
            showRenameListModal()
        default:
            break
        }
    }

}

extension ListSettingsViewController: ModalDelegate {

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

}

extension ListSettingsViewController: ListSettingsDelegate {

    func addCollaborator(collaborator: UserProfile) {
        NetworkManager.addToMediaList(listId: list.id, collaboratorIds: [collaborator.id]) { [weak self] list in
            guard let self = self else { return }
            self.list = list
//            self.addCollaboratorModalView.updateCollaborators(updatedList: list)
        }
    }

    func removeCollaborator(collaborator: UserProfile) {
        NetworkManager.removeFromMediaList(listId: list.id, collaboratorIds: [collaborator.id]) { [weak self] list in
            guard let self = self else { return }
            self.list = list
//            self.addCollaboratorModalView.updateCollaborators(updatedList: list)
        }
    }

    func deleteList() {
        NetworkManager.deleteMediaList(listId: list.id) { [weak self] _ in
            guard let self = self else { return }

            self.presentInfoAlert(message: "Deleted \(self.list.name)") {
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
    }

    func renameList(to name: String) {
        var updatedList = list
        updatedList.name = name
        NetworkManager.updateMediaList(listId: list.id, list: updatedList) { [weak self] list in
            guard let self = self else { return }
            self.list = list
            self.presentInfoAlert(message: "Renamed to \(list.name)", completion: nil)
        }
    }

    func updatePrivacy(to isPrivate: Bool) {
        var updatedList = list
        updatedList.isPrivate = isPrivate
        NetworkManager.updateMediaList(listId: list.id, list: updatedList) { [weak self] list in
            guard let self = self else { return }
            self.list = list
            self.presentInfoAlert(message: "Updated to \(list.isPrivate ? "private" : "public")", completion: nil)
        }
    }

}
