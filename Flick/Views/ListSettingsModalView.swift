//
//  ListSettingsModalView.swift
//  Flick
//
//  Created by Haiying W on 7/3/20.
//  Copyright © 2020 flick. All rights reserved.
//

enum ListSetting: String {
    case collaboration = "Collaboration"
    case deleteList = "Delete list"
    case privacy = "Privacy"
}

protocol ListSettingsDelegate: class {
    func showAddCollaboratorsModal()
}

import UIKit

class ListSettingsModalView: UIView {

    // MARK: - Private View Vars
    private let roundTopView = RoundTopView(hasShadow: true)
    private let settingsTableView = UITableView()

    // MARK: - Private Data Vars
    private let collaborators = ["A", "B", "C", "D", "E", "F", "G", "H"]
    weak var delegate: ListSettingsDelegate?
    private let listSettingsCellReuseIdentifier = "ListSettingsCellReuseIdentifier"
    // TODO: Only show privacy/delete list if user is the owner of list
    private let settings: [ListSetting] = [.collaboration, .privacy, .deleteList]

    init() {
        super.init(frame: .zero)

        addSubview(roundTopView)

        settingsTableView.separatorStyle = .none
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        settingsTableView.register(ListSettingsTableViewCell.self, forCellReuseIdentifier: listSettingsCellReuseIdentifier)
        settingsTableView.bounces = false
        addSubview(settingsTableView)

        setupConstraints()
    }

    func setupConstraints() {
        roundTopView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        settingsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListSettingsModalView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: listSettingsCellReuseIdentifier, for: indexPath) as? ListSettingsTableViewCell else { return UITableViewCell() }
        cell.configure(for: settings[indexPath.row], isPrivate: true, collaborators: collaborators) // TODO: pass in the list instead of isPrivate and collaborators
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        if setting == .collaboration {
            delegate?.showAddCollaboratorsModal()
        }
    }

}
