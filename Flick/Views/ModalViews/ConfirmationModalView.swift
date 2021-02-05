//
//  ConfirmationModalView.swift
//  Flick
//
//  Created by Haiying W on 7/11/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum ConfirmationType { case clearIdeas, deleteList, removeMedia }

protocol ClearIdeasDelegate: class {
    func clearIdeas()
}

class ConfirmationModalView: ModalView {

    // MARK: - Private View Vars
    private var grayButton = UIButton()
    private let messageLabel = UILabel()
    private var purpleButton = UIButton()
    private let subMessageLabel = UILabel()

    // MARK: - Private Data Var
    weak var clearIdeasDelegate: ClearIdeasDelegate?
    weak var editListDelegate: EditListDelegate?
    weak var listSettingsDelegate: ListSettingsDelegate?
    private var type: ConfirmationType

    init(message: String, subMessage: String? = nil, type: ConfirmationType) {
        self.type = type
        super.init()

        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.textAlignment = type == .clearIdeas ? .left : .center
        messageLabel.font = .systemFont(ofSize: 20, weight: .medium)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        containerView.addSubview(messageLabel)

        purpleButton = RoundedButton(style: .purple, title: type == .clearIdeas ? "Clear" : "No")
        purpleButton.addTarget(self, action: #selector(purpleButtonPressed), for: .touchUpInside)
        containerView.addSubview(purpleButton)

        grayButton = RoundedButton(style: .gray, title: type == .clearIdeas ? "Cancel" : "No")
        grayButton.addTarget(self, action: #selector(grayButtonPressed), for: .touchUpInside)
        containerView.addSubview(grayButton)

        if let subMessage = subMessage, type == .clearIdeas {
            subMessageLabel.text = subMessage
            subMessageLabel.textColor = .darkBlueGray2
            subMessageLabel.font = .systemFont(ofSize: 14)
            subMessageLabel.numberOfLines = 0
            containerView.addSubview(subMessageLabel)
        }

        setupConstraints()
    }

    func setupConstraints() {
        let buttonSize = CGSize(width: 70, height: 40)
        let buttonHorizontalPadding = 64
        let verticalPadding = 36

        messageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(verticalPadding)
        }

        if type == .clearIdeas {
            subMessageLabel.snp.makeConstraints { make in
                make.top.equalTo(messageLabel.snp.bottom).offset(12)
                make.leading.trailing.equalTo(messageLabel)
            }
        }

        grayButton.snp.makeConstraints { make in
            if type == .clearIdeas {
                make.top.equalTo(subMessageLabel.snp.bottom).offset(verticalPadding)
            } else {
                make.top.equalTo(messageLabel.snp.bottom).offset(verticalPadding)
            }
            make.bottom.equalToSuperview().inset(verticalPadding)
            make.size.equalTo(buttonSize)
            make.leading.equalToSuperview().offset(buttonHorizontalPadding)
        }

        purpleButton.snp.makeConstraints { make in
            make.top.equalTo(grayButton)
            make.bottom.equalToSuperview().inset(verticalPadding)
            make.size.equalTo(buttonSize)
            make.trailing.equalToSuperview().inset(buttonHorizontalPadding)
        }

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(308)
        }
    }

    @objc func grayButtonPressed() {
        dismissModal()
    }

    @objc func purpleButtonPressed() {
        dismissModal()
        switch type {
        case .clearIdeas:
            clearIdeasDelegate?.clearIdeas()
        case .deleteList:
            listSettingsDelegate?.deleteList()
        case .removeMedia:
            editListDelegate?.removeMediaFromList()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
