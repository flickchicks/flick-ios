//
//  NewListViewController.swift
//  Telie
//
//  Created by Lucy Xu on 4/5/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import NotificationBannerSwift
import NVActivityIndicatorView
import UIKit

protocol CreateGroupDelegate: class {
    func createGroup(group: Group)
}

protocol CreateListDelegate: class {
    func createList(list: MediaList)
}

protocol RenameGroupDelegate: class {
    func renameGroup(group: Group)
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

class NewListViewController: UIViewController {

    // MARK: - Private View Vars
    private var doneButton = UIButton()
    private let nameTextField = UITextField()
    private let newListButton = UIButton()
    private let titleLabel = UILabel()
    var list: MediaList?
    var group: Group?
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )

    // MARK: - Data Vars
    weak var createGroupDelegate: CreateGroupDelegate?
    weak var createListDelegate: CreateListDelegate?
    weak var listSettingsDelegate: ListSettingsDelegate?
    weak var renameGroupDelegate: RenameGroupDelegate?
    private let type: EnterNameModalType

    init(type: EnterNameModalType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        titleLabel.text = type.titleText
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        view.addSubview(titleLabel)

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
        view.addSubview(nameTextField)

        newListButton.setTitle("Save", for: .normal)
        newListButton.setTitleColor(.gradientPurple, for: .normal)
        newListButton.titleLabel?.font = .systemFont(ofSize: 14)
        newListButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        view.addSubview(newListButton)

        view.addSubview(spinner)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        nameTextField.becomeFirstResponder()
    }

    private func setupConstraints() {
        let horizontalPadding = 24
        let titleLabelSize = CGSize(width: 144, height: 22)
        let verticalPadding = 36

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalPadding)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.size.equalTo(titleLabelSize)
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(25)
        }

        newListButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(4)
            make.size.equalTo(CGSize(width: 66, height: 34))
        }

        spinner.snp.makeConstraints { make in
            make.center.equalTo(newListButton)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func doneTapped() {
        guard let nameText = nameTextField.text,
            nameText.trimmingCharacters(in: .whitespaces) != ""
            else { return }
        spinner.startAnimating()
        newListButton.isHidden = true
        switch type {
        case .createGroup:
            NetworkManager.createGroup(name: nameText) { [weak self] group in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.dismiss(animated: true) { () in
                        self.createGroupDelegate?.createGroup(group: group)
                    }
                }
            }
        case .createList:
            NetworkManager.createNewMediaList(listName: nameText) { [weak self] mediaList in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.dismiss(animated: true) { () in
                        self.createListDelegate?.createList(list: mediaList)
                    }
                }
            }
        case .renameGroup:
            guard let group = group else { return }
            NetworkManager.updateGroup(id: group.id, name: nameText) { [weak self] group in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.dismiss(animated: true) { () in
                        self.renameGroupDelegate?.renameGroup(group: group)
                    }
                }
            }
        case .renameList:
            guard let list = list else { return }
            var updatedList = list
            updatedList.name = nameText
            NetworkManager.updateMediaList(listId: list.id, list: updatedList) { [weak self] list in
                guard let self = self else { return }
                self.dismiss(animated: true) { () in
                    self.listSettingsDelegate?.renameList(to: nameText)
                }
            }
        }
    }

}

extension NewListViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
