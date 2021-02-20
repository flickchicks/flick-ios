//
//  EnterNameModalView.swift
//  Flick
//
//  Created by Lucy Xu on 7/4/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import UIKit

protocol CreateGroupDelegate: class {
    func createGroup(title: String)
}

protocol CreateListDelegate: class {
    func createList(title: String)
}

protocol RenameGroupDelegate: class {
    func renameGroup(title: String)
}

enum EnterNameModalType {
    case createGroup, createList, renameGroup, renameList

    var titleText: String {
        switch self {
        case .createGroup:
            return "Create a new group"
        case .createList:
            return "Create new list"
        case .renameGroup:
            return "Rename group"
        case .renameList:
            return "Rename list"
        }
    }
}

class EnterNameModalView: ModalView {

    // MARK: - Private View Vars
    private var cancelButton = UIButton()
    private var doneButton = UIButton()
    private let nameTextField = UITextField()
    private let titleLabel = UILabel()

    // MARK: - Data Vars
    weak var createGroupDelegate: CreateGroupDelegate?
    weak var createListDelegate: CreateListDelegate?
    weak var listSettingsDelegate: ListSettingsDelegate?
    weak var renameGroupDelegate: RenameGroupDelegate?
    private var type: EnterNameModalType!

    init(type: EnterNameModalType) {
        super.init()
        self.type = type

        titleLabel.text = type.titleText
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(titleLabel)

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

        doneButton = RoundedButton(style: .purple, title: "Done")
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        containerView.addSubview(doneButton)

        cancelButton = RoundedButton(style: .gray, title: "Cancel")
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        containerView.addSubview(cancelButton)

        setupConstraints()
    }

    func setupConstraints() {
        let buttonSize = CGSize(width: 84, height: 40)
        let containerViewSize = CGSize(width: 325, height: 220)
        let horizontalPadding = 24
        let titleLabelSize = CGSize(width: 144, height: 22)
        let verticalPadding = 36

        containerView.snp.makeConstraints { make in
            make.size.equalTo(containerViewSize)
            make.center.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(verticalPadding)
            make.leading.trailing.equalTo(containerView).inset(horizontalPadding)
            make.size.equalTo(titleLabelSize)
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(25)
        }

        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(62.5)
            make.size.equalTo(buttonSize)
            make.top.equalTo(nameTextField.snp.bottom).offset(verticalPadding)
        }

        doneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(62.5)
            make.size.equalTo(buttonSize)
            make.top.equalTo(nameTextField.snp.bottom).offset(verticalPadding)
        }
    }

    @objc func doneTapped() {
        guard let nameText = nameTextField.text,
            nameText.trimmingCharacters(in: .whitespaces) != ""
            else { return }
        switch type {
        case .createGroup:
            createGroupDelegate?.createGroup(title: nameText)
        case .createList:
            createListDelegate?.createList(title: nameText)
        case .renameGroup:
            renameGroupDelegate?.renameGroup(title: nameText)
        case .renameList:
            listSettingsDelegate?.renameList(to: nameText)
        case .none:
            break
        }
        dismissModal()
    }

    @objc func cancelTapped() {
        dismissModal()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension EnterNameModalView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
