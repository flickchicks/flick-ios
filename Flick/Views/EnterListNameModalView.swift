//
//  AddListModalView.swift
//  Flick
//
//  Created by Lucy Xu on 7/4/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import UIKit

protocol CreateListDelegate: class {
    func createList(title: String)
}

enum EnterListNameModalType { case createList, renameList }

class EnterListNameModalView: UIView {

    // MARK: - Private View Vars
    private let cancelButton = UIButton()
    private let containerView = UIView()
    private let dismissButton = UIButton()
    private let nameTextField = UITextField()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    weak var createListDelegate: CreateListDelegate?
    weak var modalDelegate: ModalDelegate?
    weak var listSettingsDelegate: ListSettingsDelegate?
    private var type: EnterListNameModalType!

    init(type: EnterListNameModalType) {
        super.init(frame: .zero)

        frame = UIScreen.main.bounds
        backgroundColor = UIColor.darkBlueGray2.withAlphaComponent(0.7)

        self.type = type
        switch type {
        case .createList:
            titleLabel.text  = "Create new list"
        case .renameList:
            titleLabel.text = "Rename list"
        }

        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(titleLabel)

        dismissButton.setTitle("Done", for: .normal)
        dismissButton.setTitleColor(.gradientPurple, for: .normal)
        dismissButton.titleLabel?.font = .systemFont(ofSize: 14)
        dismissButton.layer.cornerRadius = 12
        dismissButton.layer.backgroundColor = UIColor.lightPurple.cgColor
        dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        containerView.addSubview(dismissButton)

        nameTextField.textColor = .black
        nameTextField.placeholder = "Name"
        nameTextField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 9, height: 36))
        nameTextField.leftViewMode = .always
        nameTextField.borderStyle = .none
        nameTextField.layer.backgroundColor = UIColor.white.cgColor
        nameTextField.layer.masksToBounds = false
        nameTextField.layer.shadowColor = UIColor.mediumGray.cgColor
        nameTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        nameTextField.layer.shadowOpacity = 1.0
        nameTextField.layer.shadowRadius = 0.0
        nameTextField.delegate = self
        containerView.addSubview(nameTextField)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.mediumGray, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 14)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        containerView.addSubview(cancelButton)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        addSubview(containerView)

        setupConstraints()

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })
    }

    func setupConstraints() {
        let cancelButtonSize = CGSize(width: 47, height: 17)
        let containerViewSize = CGSize(width: 325, height: 200)
        let dismissButtonSize = CGSize(width: 60, height: 25)
        let horizontalPadding = 24
        let titleLabelSize = CGSize(width: 144, height: 22)
        let verticalPadding = 36

        containerView.snp.makeConstraints { make in
            make.size.equalTo(containerViewSize)
            make.center.equalToSuperview()
        }

        dismissButton.snp.makeConstraints { make in
            make.size.equalTo(dismissButtonSize)
            make.top.equalTo(containerView).offset(33)
            make.trailing.equalTo(containerView).inset(horizontalPadding)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(verticalPadding)
            make.leading.equalTo(containerView).offset(horizontalPadding)
            make.size.equalTo(titleLabelSize)
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(dismissButton)
            make.height.equalTo(31)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(cancelButtonSize)
            make.top.equalTo(nameTextField.snp.bottom).offset(36)
        }
    }

    @objc func dismiss() {
        guard let nameText = nameTextField.text,
            nameText.trimmingCharacters(in: .whitespaces) != ""
            else { return }
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.modalDelegate?.dismissModal(modalView: self)
            switch self.type {
            case .createList:
                self.createListDelegate?.createList(title: nameText)
            case .renameList:
                self.listSettingsDelegate?.renameList(to: nameText)
            case .none:
                break
            }
        }
    }

    @objc func cancel() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.modalDelegate?.dismissModal(modalView: self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EnterListNameModalView: UITextFieldDelegate {

}
