//
//  ConfirmationModalView.swift
//  Flick
//
//  Created by Haiying W on 7/11/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum ConfirmationType { case deleteList, removeMedia }

class ConfirmationModalView: ModalView {

    // MARK: - Private View Vars
    private let messageLabel = UILabel()
    private var noButton = UIButton()
    private var yesButton = UIButton()

    // MARK: - Private Data Var
    weak var editListDelegate: EditListDelegate?
    weak var listSettingsDelegate: ListSettingsDelegate?
    private var type: ConfirmationType

    init(message: String, type: ConfirmationType) {
        self.type = type
        super.init()

        messageLabel.text = message

        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 20, weight: .medium)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        containerView.addSubview(messageLabel)

        noButton = RoundedButton(style: .purple, title: "No")
        noButton.addTarget(self, action: #selector(noButtonPressed), for: .touchUpInside)
        containerView.addSubview(noButton)

        yesButton = RoundedButton(style: .gray, title: "Yes")
        yesButton.addTarget(self, action: #selector(yesButtonPressed), for: .touchUpInside)
        containerView.addSubview(yesButton)

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

        yesButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(verticalPadding)
            make.bottom.equalToSuperview().inset(verticalPadding)
            make.size.equalTo(buttonSize)
            make.leading.equalToSuperview().offset(buttonHorizontalPadding)
        }

        noButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(verticalPadding)
            make.bottom.equalToSuperview().inset(verticalPadding)
            make.size.equalTo(buttonSize)
            make.trailing.equalToSuperview().inset(buttonHorizontalPadding)
        }

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(308)
        }
    }

    @objc func noButtonPressed() {
        dismissModal()
    }

    @objc func yesButtonPressed() {
        dismissModal()
        switch type {
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
