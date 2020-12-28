//
//  MediaListsView.swift
//  Flick
//
//  Created by Haiying W on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class NewListButton: UIButton {

    // MARK: - Private View Vars
    private let plusImageView = UIImageView()
    private let newListLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .lightGray2
        layer.cornerRadius = 8

        plusImageView.image = UIImage(named: "plusCircle")
        addSubview(plusImageView)

        newListLabel.text = "New List"
        newListLabel.textColor = .darkBlueGray2
        addSubview(newListLabel)

        let plusImageSize = CGSize(width: 20, height: 20)
        plusImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(plusImageSize)
            make.leading.equalToSuperview().offset(10)
        }

        newListLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(plusImageView.snp.trailing).offset(5)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum MediaListsModalViewType { case moveMedia, saveMedia }

class MediaListsModalView: UIView {

    // MARK: - Private View Vars
    private var cancelButton = UIButton()
    private let containerView = UIView()
    private var doneButton = UIButton()
    private let listsTableView = UITableView()
    private let newListButton = NewListButton()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let listNameCellReuseIdentifier = "ListNameCellReuseIdentifier"
    private var lists: [SimpleMediaList] = []
    private var selectedList: SimpleMediaList?
    private var type: MediaListsModalViewType

    weak var editListDelegate: EditListDelegate?
    weak var modalDelegate: ModalDelegate?
    weak var saveMediaDelegate: SaveMediaDelegate?

    init(type: MediaListsModalViewType) {
        self.type = type
        super.init(frame: .zero)

        frame = UIScreen.main.bounds
        backgroundColor = UIColor.darkBlueGray2.withAlphaComponent(0.7)

        switch type {
        case .moveMedia:
            titleLabel.text  = "Move to"
        case .saveMedia:
            titleLabel.text = "Save to"
        }
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(titleLabel)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        addSubview(containerView)

        doneButton = RoundedButton(style: .purple, title: "Done")
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        containerView.addSubview(doneButton)

        cancelButton = RoundedButton(style: .gray, title: "Cancel")
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        containerView.addSubview(cancelButton)

        listsTableView.dataSource = self
        listsTableView.delegate = self
        listsTableView.showsVerticalScrollIndicator = false
        listsTableView.register(ListNameTableViewCell.self, forCellReuseIdentifier: listNameCellReuseIdentifier)
        listsTableView.separatorStyle = .none
        listsTableView.bounces = false
        containerView.addSubview(listsTableView)

        setupConstraints()
        getLists()

        if type == .saveMedia {
            newListButton.addTarget(self, action: #selector(newListTapped), for: .touchUpInside)
            setupNewListButton()
        }

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })
    }

    private func setupConstraints() {
        let containerViewSize = CGSize(width: 325, height: 430)
        let buttonSize = CGSize(width: 84, height: 40)
        let horizontalPadding = 24
        let titleLabelSize = CGSize(width: 144, height: 22)
        let verticalPadding = 36

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(containerViewSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(verticalPadding)
            make.leading.equalTo(containerView).offset(horizontalPadding)
            make.size.equalTo(titleLabelSize)
        }

        listsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(containerView).inset(horizontalPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }

        doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(62.5)
            make.size.equalTo(buttonSize)
            make.top.equalTo(listsTableView.snp.bottom).offset(verticalPadding)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }

        cancelButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(62.5)
            make.size.equalTo(buttonSize)
            make.top.equalTo(listsTableView.snp.bottom).offset(verticalPadding)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }
    }

    private func setupNewListButton() {
        containerView.addSubview(newListButton)

        let horizontalPadding = 24

        newListButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(containerView).inset(horizontalPadding)
            make.height.equalTo(32)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }

        listsTableView.snp.remakeConstraints { remake in
            remake.leading.trailing.equalTo(containerView).inset(horizontalPadding)
            remake.top.equalTo(newListButton.snp.bottom).offset(15)
        }
    }

    private func getLists() {
        NetworkManager.getUserProfile { [weak self] user in
            guard let self = self else { return }
            self.lists = (user.ownerLsts ?? []) + (user.collabLsts ?? [])
            self.listsTableView.reloadData()
        }
    }

    @objc func doneTapped() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.modalDelegate?.dismissModal(modalView: self)
            switch self.type {
            case .moveMedia:
                guard let selectedList = self.selectedList else { return }
                self.editListDelegate?.moveMedia(selectedList: selectedList)
            case .saveMedia:
                guard let selectedList = self.selectedList else { return }
                self.saveMediaDelegate?.saveMedia(selectedList: selectedList)
            }
        }
    }

    @objc func cancelTapped() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.modalDelegate?.dismissModal(modalView: self)
        }
    }

    @objc func newListTapped() {
        self.modalDelegate?.dismissModal(modalView: self)
        self.saveMediaDelegate?.presentCreateNewList()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MediaListsModalView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: listNameCellReuseIdentifier, for: indexPath) as? ListNameTableViewCell else { return UITableViewCell() }
        cell.configure(list: lists[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedList = lists[indexPath.row]
    }

}
