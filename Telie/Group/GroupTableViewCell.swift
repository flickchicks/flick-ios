//
//  GroupTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 2/5/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let membersLabel = UILabel()
    private let nameLabel = UILabel()
    private var usersCollectionView: UICollectionView!

    // MARK: - Data Vars
    private var group: Group?
    static let reuseIdentifier = "GroupCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .offWhite

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        containerView.layer.shadowOpacity = 0.07
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        contentView.addSubview(containerView)

        nameLabel.textColor = .darkBlue
        nameLabel.font = .systemFont(ofSize: 16)
        containerView.addSubview(nameLabel)

        membersLabel.textColor = .mediumGray
        membersLabel.font = .systemFont(ofSize: 14)
        membersLabel.numberOfLines = 2
        containerView.addSubview(membersLabel)

        let usersLayout = UICollectionViewFlowLayout()
        usersLayout.minimumInteritemSpacing = -18

        usersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: usersLayout)
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = self
        usersCollectionView.register(UserPreviewCollectionViewCell.self, forCellWithReuseIdentifier: UserPreviewCollectionViewCell.reuseIdentifier)
        usersCollectionView.backgroundColor = .none
        containerView.addSubview(usersCollectionView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(6)
        }

        usersCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.leading.equalToSuperview().offset(12)
            make.size.equalTo(CGSize(width: 52, height: 28))
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(usersCollectionView.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(22)
        }

        membersLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.trailing.equalTo(nameLabel.snp.trailing)
        }
    }

    func configure(for group: Group) {
        self.group = group
        nameLabel.text = group.name
        let membersNames = group.members.map { $0.username }
        membersLabel.text = membersNames.joined(separator: ", ")
        usersCollectionView.reloadData()
    }

}

extension GroupTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(3, group?.members.count ?? 0)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPreviewCollectionViewCell.reuseIdentifier, for: indexPath) as? UserPreviewCollectionViewCell,
              let members = group?.members else { return UICollectionViewCell() }
        cell.configure(user: members[indexPath.item], width: 28, shouldShowEllipsis: false)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 28, height: 28)
    }

}

