//
//  UsersPreviewView.swift
//  Flick
//
//  Created by Lucy Xu on 5/31/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SnapKit

enum UsersLayoutMode { case friends, collaborators }

class UsersPreviewView: UIView {

    // MARK: - Private View Vars
    private let editLabel = UILabel()
    private var usersCollectionView: UICollectionView!

    // MARK: - Private Data Vars
    private var cellSpacing: CGFloat!
    private var hasEdit: Bool = false
    private var modeCellSpacing: [UsersLayoutMode : CGFloat] = [
        .friends : -8,
        .collaborators : -5
    ]
    private let numMaxUsers = 6
    private var usersLayoutMode: UsersLayoutMode!
    private let usersCellReuseIdentifier = "UsersCellReuseIdentifier"

    var users: [UserProfile] = [] {
        didSet {
            usersCollectionView.reloadData()
        }
    }

    init(users: [UserProfile], usersLayoutMode : UsersLayoutMode, hasEdit: Bool = false) {
        self.users = users
        self.cellSpacing = modeCellSpacing[usersLayoutMode]
        self.usersLayoutMode = usersLayoutMode
        self.hasEdit = hasEdit
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let usersLayout = UICollectionViewFlowLayout()
        usersLayout.minimumInteritemSpacing = cellSpacing

        usersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: usersLayout)
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = self
        usersCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: usersCellReuseIdentifier)
        usersCollectionView.backgroundColor = .none
        addSubview(usersCollectionView)

        if hasEdit {
            setupEditMode()
        } else {
            usersCollectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    private func setupEditMode() {
        editLabel.text = "Edit"
        editLabel.textColor = .white
        editLabel.textAlignment = .center
        editLabel.font = .systemFont(ofSize: 12)
        editLabel.backgroundColor = .darkBlueGray2
        editLabel.layer.cornerRadius = 10
        editLabel.layer.borderColor = UIColor.white.cgColor
        editLabel.layer.borderWidth = 1
        editLabel.layer.masksToBounds = true
        addSubview(editLabel)

        let editLabelSize = CGSize(width: 35, height: 20)

        editLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.size.equalTo(editLabelSize)
        }
        
        usersCollectionView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalTo(editLabel.snp.leading).offset(-cellSpacing)
        }
    }

    func getUsersPreviewWidth() {
        
    }
}

extension UsersPreviewView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Always want to render the ellipsis for friends view but only do it for collaborators view if user count exceeds max
        if users.count == 0 {
            return 0
        }
        else {
            return (usersLayoutMode == .collaborators && users.count < numMaxUsers) ? users.count : numMaxUsers + 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: usersCellReuseIdentifier, for: indexPath)
        let user = users[indexPath.item]
        cell.backgroundColor = .deepPurple
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 10
        if let pictureUrl = URL(string: user.profilePic.assetUrls.small), let pictureData = try? Data(contentsOf: pictureUrl) {
            let pictureObject = UIImage(data: pictureData)
            cell.backgroundView = UIImageView(image: pictureObject)
        }
        if indexPath.item == numMaxUsers {
            cell.backgroundView = UIImageView(image: UIImage(named: "ellipsis"))
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

}
