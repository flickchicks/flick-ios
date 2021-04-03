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
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let collaboratorsPreviewView = UsersPreviewView(users: [], usersLayoutMode: .collaborators)
    private var list: SimpleMediaList!
    private let lockImageView = UIImageView()
    private var media: [SimpleMedia] = []
    private let mediaCellReuseIdentifier = "MediaCellReuseIdentifier"

    weak var delegate: SaveMediaDelegate?

    static let reuseIdentifier = "SaveToListTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        isUserInteractionEnabled = true

        selectionStyle = .gray
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        titleLabel.linesCornerRadius = 6
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 14)

        contentView.addSubview(titleLabel)

        let mediaLayout = UICollectionViewFlowLayout()
        mediaLayout.minimumInteritemSpacing = 12
        mediaLayout.scrollDirection = .horizontal

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(saveMedia))
        mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mediaLayout)
        mediaCollectionView.register(MediaInListCollectionViewCell.self, forCellWithReuseIdentifier: mediaCellReuseIdentifier)
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.contentInset = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 16)
        mediaCollectionView.backgroundColor = .clear
        mediaCollectionView.showsHorizontalScrollIndicator = false
        mediaCollectionView.allowsSelection = false
        mediaCollectionView.addGestureRecognizer(tapGestureRecognizer)
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
            // Temporarily set as 0, update on cell configure
            make.width.equalTo(0)
            make.bottom.equalTo(titleLabel)
        }
    }

    func configure(for list: SimpleMediaList, delegate: SaveMediaDelegate) {
        self.list = list
        self.media = list.shows
        self.delegate = delegate
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

    @objc func saveMedia() {
        guard let list = list else { return }
        delegate?.saveMedia(selectedList: list)
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
