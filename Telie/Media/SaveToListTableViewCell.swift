//
//  SaveToListTableViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/30/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

class SaveToListTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private var mediaCollectionView: UICollectionView!
    private let saveToListButton = RoundedButton(style: .purple, title: "Add")
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let collaboratorsPreviewView = UsersPreviewView(users: [], usersLayoutMode: .collaborators)
    private var list: SimpleMediaList!
    private let lockImageView = UIImageView()
    private var media: [SimpleMedia] = []
    private let mediaCellReuseIdentifier = "MediaCellReuseIdentifier"

    static let reuseIdentifier = "SaveToListTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        titleLabel.skeletonCornerRadius = 6
        titleLabel.linesCornerRadius = 6
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 14)

        titleLabel.isSkeletonable = true
        contentView.addSubview(titleLabel)

        saveToListButton.titleLabel?.font = .systemFont(ofSize: 12)
        saveToListButton.layer.cornerRadius = 10
        saveToListButton.addTarget(self, action: #selector(saveToListTapped), for: .touchUpInside)
        contentView.addSubview(saveToListButton)

        let mediaLayout = UICollectionViewFlowLayout()
        mediaLayout.minimumInteritemSpacing = 12
        mediaLayout.scrollDirection = .horizontal

        mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mediaLayout)
        mediaCollectionView.register(MediaInListCollectionViewCell.self, forCellWithReuseIdentifier: mediaCellReuseIdentifier)
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.contentInset = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 16)
        mediaCollectionView.backgroundColor = .clear
        mediaCollectionView.showsHorizontalScrollIndicator = false
        mediaCollectionView.isSkeletonable = true
        contentView.addSubview(mediaCollectionView)

        lockImageView.image = UIImage(named: "lock")
        lockImageView.isHidden = true
        contentView.addSubview(lockImageView)
        collaboratorsPreviewView.isHidden = true
        contentView.addSubview(collaboratorsPreviewView)

        setupConstraints()
    }

    func setupCollaborators(collaborators: [UserProfile]) {
        collaboratorsPreviewView.users = collaborators

        let collaboratorsPreviewWidth = collaboratorsPreviewView.getUsersPreviewWidth()

        collaboratorsPreviewView.snp.updateConstraints { update in
            update.width.equalTo(collaboratorsPreviewWidth)
        }
    }

    private func setupConstraints() {
        let padding = 12

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.leading.equalToSuperview().offset(34)
            make.height.equalTo(17)
        }

        saveToListButton.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel)
            make.size.equalTo(CGSize(width: 42, height: 20))
            make.trailing.equalToSuperview().inset(24)
        }

        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(padding)
            make.height.equalTo(120)
        }

        lockImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.height.equalTo(13)
            make.width.equalTo(10)
            make.centerY.equalTo(titleLabel)
        }

        collaboratorsPreviewView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(0) // Temporarily set as 0, but it will be updated when configuring the cell
            make.bottom.equalTo(titleLabel)
        }
    }

    func configure(for list: SimpleMediaList) {
        self.list = list
        self.media = list.shows
        // If there are no shows added, show empty state but no scroll
        mediaCollectionView.isScrollEnabled = self.media.count != 0
        titleLabel.text = list.name
        let listCollaborators = [list.owner] + list.collaborators
        lockImageView.isHidden = !list.isPrivate
        // collaboratorsPreviewView does not show if list is private
        collaboratorsPreviewView.isHidden = list.isPrivate
        if listCollaborators.count > 1 {
            setupCollaborators(collaborators: listCollaborators)
        }
        mediaCollectionView.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        collaboratorsPreviewView.users = []
    }

    @objc func saveToListTapped() {
        print("saved")
    }

}

extension SaveToListTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If list is empty, show 4 filler cells
        if media.isEmpty {
            return 4
        } else {
            return media.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifier, for: indexPath) as? MediaInListCollectionViewCell else { return UICollectionViewCell() }
        if media.count != 0 {
            let media = self.media[indexPath.row]
            cell.configure(media: media)
        }
        return cell
    }
}

extension SaveToListTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}
