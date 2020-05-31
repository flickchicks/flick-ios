//
//  FriendsCollectionView.swift
//  Flick
//
//  Created by Lucy Xu on 5/31/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SnapKit

enum FriendsLayoutMode { case expanded, condensed }

class FriendsView: UIView {

    private var friendsCollectionView: UICollectionView!
    private let friendsCellReuseIdentifier = "FriendsCellReuseIdentifier"
    private var friends: [User] = []
    private var layoutMode: FriendsLayoutMode!

    init(friends: [User], layoutMode: FriendsLayoutMode) {
        self.friends = friends
        self.layoutMode = layoutMode
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        let friendsLayout = UICollectionViewFlowLayout()
        friendsLayout.minimumInteritemSpacing = -10

        friendsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: friendsLayout)
        friendsCollectionView.delegate = self
        friendsCollectionView.dataSource = self
        friendsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: friendsCellReuseIdentifier)
        friendsCollectionView.backgroundColor = .white
        addSubview(friendsCollectionView)
        
    }

    func setupConstraints() {

    }

}

extension FriendsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: friendsCellReuseIdentifier, for: indexPath)
        cell.backgroundColor = .deepPurple
        cell.backgroundView = UIImageView(image: UIImage(named: "temp"))
        cell.layer.cornerRadius = 10
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

}
