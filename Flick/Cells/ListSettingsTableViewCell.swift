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
    private var collaboratorsPreviewView: UsersPreviewView!
    private let nameLabel = UILabel()
    private let privacyStatusLabel = UILabel()
    private let privacySwitch = PrivacySwitch()

    // MARK: - Private Data Vars
    private var collaborators: [String] = []
    private let collaboratorsCellSpacing = -5

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

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

    func configure(for setting: ListSetting, list: MediaList) {
        nameLabel.text = setting.rawValue
        switch setting {
        case.collaboration:
//            self.collaborators = collaborators
//            collaboratorsPreviewView = UsersPreviewView(users: collaborators, usersLayoutMode: .collaborators, isEdit: true)
            contentView.addSubview(collaboratorsPreviewView)
            setupCollaboratorsConstraints()
        case .deleteList:
            break
        case .privacy:
//            privacyStatusLabel.text = isPrivate ? "Only I can view" : "Anyone can view"
//            privacySwitch.setPrivate(isPrivate)
            contentView.addSubview(privacyStatusLabel)
            contentView.addSubview(privacySwitch)
            setupPrivacyConstraints()
        case .rename:
            break
        }
    }

    private func setupCollaboratorsConstraints() {
        let numCollaborators = min(collaborators.count, 7)
        let fullCollaboratorsWidth = numCollaborators * 20
        let overlapCollaboratorsWidth = numCollaborators * collaboratorsCellSpacing * -1
        let collaboratorsPreviewWidth = fullCollaboratorsWidth - overlapCollaboratorsWidth + 35 // +40 to show "Edit"
    
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
        privacyStatusLabel.text = isPrivate ? "Only I can view" : "Anyone can view"
    }

}
