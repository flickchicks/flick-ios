//
//  ListSettingsViewController.swift
//  Flick
//
//  Created by Haiying W on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol ListSettingsDelegate: class {
    func deleteList()
    func renameList(to name: String)
    func updateCollaborators(to collaborators: [UserProfile])
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
    private let settingsTableView = UITableView()

    // MARK: - Private Data Vars
    private var list: MediaList
    private let listSettingsCellReuseIdentifier = "ListSettingsCellReuseIdentifier"
    private var settings = [ListSetting]()

    init(list: MediaList) {
        self.list = list
        super.init(nibName: nil, bundle: nil)

        if list.isSaved || list.isWatchLater {
            settings = [.privacy]
        } else {
            settings = [.collaboration, .privacy, .rename, .deleteList] // TODO: Only show collaboration if user is not owner
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        setupNavigationBar()

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

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)
            
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = .offWhite
        navigationController?.navigationBar.shadowImage = UIImage()

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
    
    private func showModalPopup(view: UIView) {
        if let window = UIApplication.shared.windows.first(where: { window -> Bool in window.isKeyWindow}) {
            window.addSubview(view)
        }
    }

    private func showAddCollaboratorsModal() {
        let addCollaboratorModalView = AddCollaboratorModalView(owner: list.owner, collaborators: list.collaborators)
        addCollaboratorModalView.modalDelegate = self
        addCollaboratorModalView.listSettingsDelegate = self
        showModalPopup(view: addCollaboratorModalView)
    }

    private func showDeleteConfirmationModal() {
        let deleteConfirmationModalView = ConfirmationModalView(message: "Are you sure you want to delete this list?")
        deleteConfirmationModalView.modalDelegate = self
        deleteConfirmationModalView.listSettingsDelegate = self
        showModalPopup(view: deleteConfirmationModalView)
    }

    private func showRenameListModal() {
        let renameListModalView = EnterListNameModalView(type: .renameList)
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

    func deleteList() {
        NetworkManager.deleteMediaList(listId: list.lstId) { _ in
            let alert = UIAlertController(title: nil, message: "Deleted \(self.list.lstName)", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.dismiss(animated: true, completion: nil)

            //TODO: should navigate user back to profile screen
        }
    }

    func renameList(to name: String) {
        var updatedList = list
        updatedList.lstName = name
        NetworkManager.updateMediaList(listId: list.lstId, list: updatedList) { list in
            let alert = UIAlertController(title: nil, message: "Renamed to \(list.lstName)", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.dismiss(animated: true, completion: nil)

            //TODO: should go back to list
        }
    }

    func updateCollaborators(to collaborators: [UserProfile]) {
        var updatedList = list
        updatedList.collaborators = collaborators
        NetworkManager.updateMediaList(listId: list.lstId, list: updatedList) { list in
            let alert = UIAlertController(title: nil, message: "Invite sent!", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.dismiss(animated: true, completion: nil)
        }
    }

    func updatePrivacy(to isPrivate: Bool) {
        var updatedList = list
        updatedList.isPrivate = isPrivate
        NetworkManager.updateMediaList(listId: list.lstId, list: updatedList) { list in
            let alert = UIAlertController(title: nil, message: "Updated to \(list.isPrivate ? "private" : "public")", preferredStyle: .alert)
            self.present(alert, animated: true)
            alert.dismiss(animated: true, completion: nil)
        }
    }

}
