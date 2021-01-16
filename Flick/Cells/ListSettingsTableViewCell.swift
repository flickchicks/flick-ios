//
//  ListSettingsTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class ListSettingsTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private var collaboratorsPreviewView = UsersPreviewView(users: [], usersLayoutMode: .collaborators, hasEdit: true)
    private let nameLabel = UILabel()
    private let privacyStatusLabel = UILabel()
    private let privacySwitch = PrivacySwitch()

    // MARK: - Private Data Vars
    private var list: MediaList!
    private var collaborators: [UserProfile] = []

    weak var listSettingsDelegate: ListSettingsDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .offWhite

        selectionStyle = .none

        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .darkBlueGray2
        contentView.addSubview(nameLabel)

        privacyStatusLabel.font = .systemFont(ofSize: 12)
        privacyStatusLabel.textColor = .mediumGray

        privacySwitch.delegate = self

        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }

    func configure(for setting: ListSetting, list: MediaList, delegate: ListSettingsDelegate) {
        self.list = list
        listSettingsDelegate = delegate
        nameLabel.text = setting.rawValue
        switch setting {
        case .collaboration:
            collaborators = list.collaborators
            collaboratorsPreviewView.users = collaborators
            contentView.addSubview(collaboratorsPreviewView)
            setupCollaboratorsConstraints()
        case .privacy:
            let isPrivate = list.isPrivate
            privacyStatusLabel.text = isPrivate ? Constants.Privacy.privateList : Constants.Privacy.publicList
            privacySwitch.isPrivate = isPrivate
            contentView.addSubview(privacyStatusLabel)
            contentView.addSubview(privacySwitch)
            setupPrivacyConstraints()
        case .deleteList:
            nameLabel.textColor = .flickRed
        default:
            break
        }
    }

    private func setupCollaboratorsConstraints() {
        let collaboratorsPreviewWidth = collaboratorsPreviewView.getUsersPreviewWidth()

        collaboratorsPreviewView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
            make.width.equalTo(collaboratorsPreviewWidth)
        }
    }

    private func setupPrivacyConstraints() {
        let switchSize = CGSize(width: 52, height: 28)

        privacyStatusLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(privacySwitch.snp.leading).offset(-8)
        }

        privacySwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(switchSize)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListSettingsTableViewCell: PrivacySwitchDelegate {

    func privacyChanged(isPrivate: Bool) {
        privacyStatusLabel.text = isPrivate ? Constants.Privacy.privateList: Constants.Privacy.publicList
        listSettingsDelegate?.updatePrivacy(to: isPrivate)
    }

}
