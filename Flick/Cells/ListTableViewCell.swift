//
//  ListTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 5/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SnapKit

class ListTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private var mediaCollectionView: UICollectionView!
    private let seeAllButton = UIButton()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private var collaboratorsCellSpacing: Int!
    private var list: MediaList!
    private var media: [Media]!
    private let mediaCellReuseIdentifier = "MediaCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(titleLabel)

        seeAllButton.setTitle("See all", for: .normal)
        seeAllButton.setTitleColor(.darkBlueGray2, for: .normal)
        seeAllButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
        seeAllButton.addTarget(self, action: #selector(seeAllMedia), for: .touchUpInside)
        contentView.addSubview(seeAllButton)

        let mediaLayout = UICollectionViewFlowLayout()
        mediaLayout.minimumInteritemSpacing = 12
        mediaLayout.scrollDirection = .horizontal

        mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mediaLayout)
        mediaCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: mediaCellReuseIdentifier)
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.contentInset = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 0)
        mediaCollectionView.backgroundColor = .none
        mediaCollectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(mediaCollectionView)

        setupConstraints()
    }

    func setupCollaborators(collaborators: [String]) {
        let collaboratorsPreviewView = UsersPreviewView(users: collaborators, usersLayoutMode: .collaborators)
        addSubview(collaboratorsPreviewView)

        // Calculate width of friends preview based on number of friends and spacing between cells
        let numCollaborators = min(collaborators.count + 1, 7)
        let fullCollaboratorsWidth = numCollaborators * 20
        let overlapCollaboratorsWidth = (numCollaborators-1) * collaboratorsCellSpacing * -1
        let collaboratorsPreviewWidth = fullCollaboratorsWidth - overlapCollaboratorsWidth

        collaboratorsPreviewView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(collaboratorsPreviewWidth)
            make.bottom.equalTo(titleLabel)
        }
    }

    func setupPrivateIcon() {
        let lockImageView = UIImageView(image: UIImage(named: "lock"))
        addSubview(lockImageView)

        lockImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.height.equalTo(13)
            make.width.equalTo(10)
            make.centerY.equalTo(titleLabel)
        }
    }

    @objc private func seeAllMedia() {
        // TODO: Implement see all media action
//        let listViewController = ListViewController()
//        self.navigationController?.pushViewController(listViewController, animated: true)

    }

    private func setupConstraints() {
        let padding = 12

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.leading.equalToSuperview().offset(34)
            make.height.equalTo(17)
        }

        seeAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(titleLabel)
            make.height.equalTo(15)
        }

        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(padding)
        }
    }

    func configure(for list: MediaList, collaboratorsCellSpacing: Int) {
        self.list = list
        self.media = list.shows
        // If there are no shows added, show empty state but no scroll
        mediaCollectionView.isScrollEnabled = self.media.count != 0
        self.collaboratorsCellSpacing = collaboratorsCellSpacing
        titleLabel.text = list.lstName
        // TODO: Are these inclusive or exclusive?
        let listCollaborators = list.collaborators
        if listCollaborators.count > 0 {
            setupCollaborators(collaborators: listCollaborators)
        } else if list.isPrivate {
            setupPrivateIcon()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension ListTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Implement select movie action
    }

}

extension ListTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If list is empty, show 4 filler cells
        return media.count == 0 ? 4 : media.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: Add media background as cell backgroundview
        // TODO: Add left padding to first cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifier, for: indexPath)
        cell.backgroundColor = .lightGray3
        cell.layer.cornerRadius = 8
        return cell
    }
}

extension ListTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}
