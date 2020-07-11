//
//  ListSettingsViewController.swift
//  Flick
//
//  Created by Haiying W on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

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
    private var list: MediaList!
    private let listSettingsCellReuseIdentifier = "ListSettingsCellReuseIdentifier"
     // TODO: Only show privacy/delete list if user is the owner of list
    private let settings: [ListSetting] = [.collaboration, .privacy, .rename, .deleteList]

    init(list: MediaList) {
        self.list = list
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTableView.separatorStyle = .none
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

}

extension ListSettingsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: listSettingsCellReuseIdentifier, for: indexPath) as? ListSettingsTableViewCell else { return UITableViewCell() }
        cell.configure(for: settings[indexPath.row], list: list) // TODO: pass in the list instead of isPrivate and collaborators
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        switch setting {
        case <#pattern#>:
            <#code#>
        default:
            <#code#>
        }
    }

}
