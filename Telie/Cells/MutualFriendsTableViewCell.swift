//
//  MutualFriendsTableViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

struct MutualFriend {

    let name: String
    let profile: String
    let username: String
    let numMutual: Int

}

class MutualFriendsTableViewCell: UITableViewCell {

    private let titleLabel = UILabel()
    private var mutualFriendsCollectionView: UICollectionView!
    private var mutualFriends: [MutualFriend] = []

    static var reuseIdentifier = "MutualFriendsTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        titleLabel.text = "👥 Soon-to-be Friends"
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .darkBlueGray2
        contentView.addSubview(titleLabel)

        let horizontalLayout = UICollectionViewFlowLayout()
        horizontalLayout.scrollDirection = .horizontal
        horizontalLayout.minimumInteritemSpacing = 12

        mutualFriendsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: horizontalLayout)
        mutualFriendsCollectionView.backgroundColor = .clear
        mutualFriendsCollectionView.delegate = self
        mutualFriendsCollectionView.dataSource = self
        mutualFriendsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        mutualFriendsCollectionView.register(MutualFriendCollectionViewCell.self, forCellWithReuseIdentifier: MutualFriendCollectionViewCell.reuseIdentifier)
        mutualFriendsCollectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(mutualFriendsCollectionView)

        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(15)
        }

        mutualFriendsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(124)
        }

    }

    func configure(with mutualFriends: [MutualFriend]) {
        self.mutualFriends = mutualFriends
        mutualFriendsCollectionView.reloadData()
    }

}

extension MutualFriendsTableViewCell: UICollectionViewDelegate {

}

extension MutualFriendsTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mutualFriends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MutualFriendCollectionViewCell.reuseIdentifier, for: indexPath) as? MutualFriendCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(for: mutualFriends[indexPath.item])
        return cell
    }

}

extension MutualFriendsTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 98, height: 124)
    }

}
