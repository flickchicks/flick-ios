//
//  MutualFriendsTableViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

protocol DiscoverDelegate: class {
    func navigateFriend(id: Int)
    func navigateList(id: Int)
    func navigateShow(id: Int, mediaName: String)
}

class MutualFriendsTableViewCell: UITableViewCell {

    private var mutualFriends: [FriendRecommendation] = []
    private var mutualFriendsCollectionView: UICollectionView!
    private let titleLabel = UILabel()

    weak var discoverDelegate: DiscoverDelegate?
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
            make.bottom.equalToSuperview().inset(30)
        }
    }

    func configure(with mutualFriends: [FriendRecommendation]) {
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MutualFriendCollectionViewCell.reuseIdentifier, for: indexPath)
                as? MutualFriendCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(for: mutualFriends[indexPath.item])
        return cell
    }
}

extension MutualFriendsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 98, height: 124)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let friend = mutualFriends[indexPath.item]
        discoverDelegate?.navigateFriend(id: friend.id)
        AnalyticsManager.logSelectContent(
            contentType: SelectContentType.Discover.friendSuggestion,
            itemId: friend.id
        )
    }
}
