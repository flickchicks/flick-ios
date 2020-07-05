//
//  ListSettingsTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 7/4/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class ListSettingsTableViewCell: UITableViewCell {

    private var collaboratorsPreviewView: UsersPreviewView!
    private let nameLabel = UILabel()

    private let collaborators = ["A", "B", "C", "D", "E", "F", "G", "H"]
    private let collaboratorsCellSpacing = -5

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        collaboratorsPreviewView = UsersPreviewView(users: collaborators, usersLayoutMode: .collaborators)
        
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textColor = .darkBlueGray2
        contentView.addSubview(nameLabel)

        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(36)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }

    func configure(for setting: ListSetting) {
        nameLabel.text = setting.rawValue
        switch setting {
        case.collaboration:
            contentView.addSubview(collaboratorsPreviewView)
            setupCollaboratorsConstraints()
        case .deleteList:
            break
        case .privacy:
            break
        }
    }
    
    private func setupCollaboratorsConstraints() {
        let numCollaborators = min(collaborators.count, 8)
        let fullCollaboratorsWidth = numCollaborators * 20
        let overlapCollaboratorsWidth = (numCollaborators - 1) * collaboratorsCellSpacing * -1
        let collaboratorsPreviewWidth = fullCollaboratorsWidth - overlapCollaboratorsWidth
    
        collaboratorsPreviewView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
            make.width.equalTo(collaboratorsPreviewWidth)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
