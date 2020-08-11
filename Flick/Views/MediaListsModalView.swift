//
//  MediaListsView.swift
//  Flick
//
//  Created by Haiying W on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum MediaListsModalViewType { case moveMedia, saveMedia }

class MediaListsModalView: UIView {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let doneButton = UIButton()
    private let listsTableView = UITableView()
    private let newListButton = UIButton()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let listNameCellReuseIdentifier = "ListNameCellReuseIdentifier"
    private var lists: [MediaList] = []
    private var type: MediaListsModalViewType!

    weak var modalDelegate: ModalDelegate?

    init(type: MediaListsModalViewType) {
        super.init(frame: .zero)

        frame = UIScreen.main.bounds
        backgroundColor = UIColor.darkBlueGray2.withAlphaComponent(0.7)

        self.type = type
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

        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.gradientPurple, for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 14)
        doneButton.layer.cornerRadius = 12
        doneButton.layer.backgroundColor = UIColor.lightPurple.cgColor
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        containerView.addSubview(doneButton)

        listsTableView.dataSource = self
        listsTableView.delegate = self
        listsTableView.showsVerticalScrollIndicator = false
        listsTableView.register(ListNameTableViewCell.self, forCellReuseIdentifier: listNameCellReuseIdentifier)
        listsTableView.separatorStyle = .none
        containerView.addSubview(listsTableView)

        setupConstraints()
        getLists()

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })
    }

    private func setupConstraints() {
        let containerViewSize = CGSize(width: 325, height: 430)
        let doneButtonSize = CGSize(width: 60, height: 25)
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

        doneButton.snp.makeConstraints { make in
            make.size.equalTo(doneButtonSize)
            make.top.equalTo(containerView).offset(33)
            make.trailing.equalTo(containerView).inset(horizontalPadding)
        }

        listsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(containerView).inset(horizontalPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }
    }

    private func getLists() {
        NetworkManager.getAllMediaLists { [weak self] lists in
            guard let self = self else { return }
            self.lists = lists
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
        }
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

}
