//
//  ConfirmationModalView.swift
//  Flick
//
//  Created by Haiying W on 7/11/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum ConfirmationType { case deleteList, removeMedia }

class ConfirmationModalView: UIView {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let messageLabel = UILabel()
    private var noButton = UIButton()
    private var yesButton = UIButton()

    // MARK: - Private Data Var
    weak var editListDelegate: EditListDelegate?
    weak var listSettingsDelegate: ListSettingsDelegate?
    weak var modalDelegate: ModalDelegate?
    private var type: ConfirmationType

    init(message: String, type: ConfirmationType) {
        self.type = type
        super.init(frame: .zero)

        messageLabel.text = message

        frame = UIScreen.main.bounds
        backgroundColor = UIColor.darkBlueGray2.withAlphaComponent(0.7)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        addSubview(containerView)

        messageLabel.textColor = .black
        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 20, weight: .medium)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        containerView.addSubview(messageLabel)

        noButton = PurpleRoundButton(title: "No")
        noButton.addTarget(self, action: #selector(noButtonPressed), for: .touchUpInside)
        containerView.addSubview(noButton)

        yesButton = GrayRoundButton(title: "Yes")
        yesButton.addTarget(self, action: #selector(yesButtonPressed), for: .touchUpInside)
        containerView.addSubview(yesButton)

        setupConstraints()

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })
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
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.modalDelegate?.dismissModal(modalView: self)
        }
    }

    @objc func yesButtonPressed() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.modalDelegate?.dismissModal(modalView: self)
        }
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
