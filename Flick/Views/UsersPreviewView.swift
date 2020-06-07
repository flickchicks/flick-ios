//
//  UsersPreviewView.swift
//  Flick
//
//  Created by Lucy Xu on 5/31/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SnapKit

class UsersPreviewView: UIView {

    // MARK: - Private View Vars
    private var friendsCollectionView: UICollectionView!

    // MARK: - Private Data Vars
    // TODO: Replace friends with User array after networking is done
//    private var friends: [User] = []
    private var cellSpacing: CGFloat!
    private var friends: [String] = []
    private let friendsCellReuseIdentifier = "FriendsCellReuseIdentifier"
    private var friendsPreview: [String] = []
    private let numMaxFriends = 7

    init(friends: [String], cellSpacing: Int) {
        self.friends = friends
        self.cellSpacing = CGFloat(cellSpacing)
        super.init(frame: .zero)
        getFriendsPreview()
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Sets friendsPreview to first numMaxFriends friends in array if number of friends in array exceeds
    /// numMaxFriends, otherwise sets friendsPreview to friends
    func getFriendsPreview() {
        friendsPreview = Array(friends.prefix(numMaxFriends))
    }

    func setupViews() {

        let friendsLayout = UICollectionViewFlowLayout()
        friendsLayout.minimumInteritemSpacing = cellSpacing

        friendsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: friendsLayout)
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        friendsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: friendsCellReuseIdentifier)
        friendsCollectionView.backgroundColor = .none
        addSubview(friendsCollectionView)
        
    }

    func setupConstraints() {
        friendsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension UsersPreviewView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellSpacing == -8 ? friendsPreview.count + 1 : friendsPreview.count // Add one more cell for last detail cell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: friendsCellReuseIdentifier, for: indexPath)
        cell.backgroundColor = .deepPurple
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 0.625
        cell.layer.cornerRadius = 10
        let cellImage = indexPath.item == friendsPreview.count ? "ellipsis" : "temp"
        // Note: Ellipsis image seems low quality
        cell.backgroundView = UIImageView(image: UIImage(named: cellImage))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

}
