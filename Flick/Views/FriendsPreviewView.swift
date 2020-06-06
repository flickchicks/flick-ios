//
//  FriendsPreviewView.swift
//  Flick
//
//  Created by Lucy Xu on 5/31/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SnapKit

enum FriendsLayoutMode { case expanded, condensed }

class FriendsPreviewView: UIView {

    // MARK: - Private View Vars
    private var friendsCollectionView: UICollectionView!

    // MARK: - Private Data Vars
//    private var friends: [User] = []
    private var friends: [String] = []
    private let friendsCellReuseIdentifier = "FriendsCellReuseIdentifier"
    private let numMaxFriends = 7
    private var cellSpacing: CGFloat!
    private var friendsPreview: [String] = []

    init(friends: [String], layoutMode: FriendsLayoutMode) {
        self.friends = friends
        switch layoutMode {
        case .condensed:
            self.cellSpacing = -8
        case .expanded:
            self.cellSpacing = -5
        }
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
        friendsCollectionView.backgroundColor = .white
        addSubview(friendsCollectionView)
        
    }

    func setupConstraints() {
        friendsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension FriendsPreviewView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendsPreview.count + 1 // Add one more cell for last detail cell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == friendsPreview.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: friendsCellReuseIdentifier, for: indexPath)
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 0.625
            cell.backgroundView = UIImageView(image: UIImage(named: "ellipsis")) // Note: Image seems low quality
            cell.layer.cornerRadius = 10
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: friendsCellReuseIdentifier, for: indexPath)
            cell.backgroundColor = .deepPurple
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 0.625
            cell.backgroundView = UIImageView(image: UIImage(named: "temp"))
            cell.layer.cornerRadius = 10
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

}
