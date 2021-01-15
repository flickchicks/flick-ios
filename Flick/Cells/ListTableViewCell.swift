//
//  ListTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 5/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SkeletonView

protocol ListTableViewCellDelegate: class {
    func pushListViewController(listId: Int)
    func pushMediaViewController(mediaId: Int, mediaImageUrl: String?)
}

class ListTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private var mediaCollectionView: UICollectionView!
    private let seeAllButton = UIButton()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let collaboratorsPreviewView = UsersPreviewView(users: [], usersLayoutMode: .collaborators)
    weak var delegate: ListTableViewCellDelegate?
    private var list: SimpleMediaList!
    private let lockImageView = UIImageView()
    private var media: [SimpleMedia] = []
    private let mediaCellReuseIdentifier = "MediaCellReuseIdentifier"
    private let seeAllCellReuseIdentifier = "SeeAllCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        isSkeletonable = true
        contentView.isSkeletonable = true

        titleLabel.text = "                   " // Setting empty spaces for skeleton view
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.isSkeletonable = true
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
        mediaCollectionView.register(MediaInListCollectionViewCell.self, forCellWithReuseIdentifier: mediaCellReuseIdentifier)
        mediaCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: seeAllCellReuseIdentifier)
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.contentInset = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 16)
        mediaCollectionView.backgroundColor = .clear
        mediaCollectionView.showsHorizontalScrollIndicator = false
        mediaCollectionView.isSkeletonable = true
        contentView.addSubview(mediaCollectionView)

        contentView.addSubview(lockImageView)
        contentView.addSubview(collaboratorsPreviewView)

        setupConstraints()
    }

    func setupCollaborators(collaborators: [UserProfile]) {
        collaboratorsPreviewView.users = collaborators

        let collaboratorsPreviewWidth = collaboratorsPreviewView.getUsersPreviewWidth()

        collaboratorsPreviewView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(collaboratorsPreviewWidth)
            make.bottom.equalTo(titleLabel)
        }
    }

    func setupPrivateIcon() {
        lockImageView.image = UIImage(named: "lock")

        lockImageView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(10)
            make.height.equalTo(13)
            make.width.equalTo(10)
            make.centerY.equalTo(titleLabel)
        }
    }

    @objc private func seeAllMedia() {
        delegate?.pushListViewController(listId: list.id)
    }

    private func setupConstraints() {
        let padding = 12

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.leading.equalToSuperview().offset(34)
            make.height.equalTo(17)
        }

        seeAllButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(mediaCollectionView.snp.top)
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(80)
        }

        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(padding)
            make.height.equalTo(120)
        }
    }

    func configure(for list: SimpleMediaList) {
        self.list = list
        self.media = list.shows
        // If there are no shows added, show empty state but no scroll
        mediaCollectionView.isScrollEnabled = self.media.count != 0
        titleLabel.text = list.name
        let listCollaborators = list.collaborators
        if list.isPrivate {
            setupPrivateIcon()
        } else if listCollaborators.count > 0 {
            setupCollaborators(collaborators: listCollaborators)
        }
        mediaCollectionView.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension ListTableViewCell: SkeletonCollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 10 || indexPath.row >= media.count {
            delegate?.pushListViewController(listId: list.id)
        } else {
            delegate?.pushMediaViewController(mediaId: media[indexPath.row].id, mediaImageUrl: media[indexPath.row].posterPic)
        }
    }
}

extension ListTableViewCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return indexPath.item == 10 ? seeAllCellReuseIdentifier : mediaCellReuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If list is empty, show 4 filler cells
        if media.isEmpty {
            return 4
        } else {
            return media.count == 10 ? media.count + 1 : media.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 10 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: seeAllCellReuseIdentifier, for: indexPath)
            cell.backgroundColor = .lightGray2
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 8
            let seeAllLabel = UILabel()
            seeAllLabel.text = "See All"
            seeAllLabel.textColor = .darkBlueGray2
            seeAllLabel.font = .systemFont(ofSize: 12)
            cell.contentView.addSubview(seeAllLabel)
            seeAllLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifier, for: indexPath) as? MediaInListCollectionViewCell else { return UICollectionViewCell() }
            if media.count != 0 {
                let media = self.media[indexPath.row]
                cell.configure(media: media)
            }
            return cell
        }
    }

}

extension ListTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}
