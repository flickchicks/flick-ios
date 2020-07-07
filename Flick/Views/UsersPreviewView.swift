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
    private var isEdit: Bool = false
    private var modeCellSpacing: [UsersLayoutMode : CGFloat] = [
        .friends : -8,
        .collaborators : -5
    ]
    private let numMaxUsers = 6
    // TODO: Replace users with User array after networking is done
//    private var users: [User] = []
    private var users: [String] = []
    private var usersLayoutMode: UsersLayoutMode!
    private let usersCellReuseIdentifier = "UsersCellReuseIdentifier"
    private var usersPreview: [String] = []

    init(users: [String], usersLayoutMode : UsersLayoutMode, isEdit: Bool = false) {
        self.users = users
        self.cellSpacing = modeCellSpacing[usersLayoutMode]
        self.usersLayoutMode = usersLayoutMode
        self.isEdit = isEdit
        super.init(frame: .zero)
        getUsersPreview()
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Sets usersPreview to first numMaxusers users in array if number of users in array exceeds
    /// numMaxusers, otherwise sets usersPreview to users
    func getUsersPreview() {
        usersPreview = Array(users.prefix(numMaxUsers))
    }

    func setupViews() {
        editLabel.text = "Edit"
        editLabel.textColor = .white
        editLabel.textAlignment = .center
        editLabel.font = .systemFont(ofSize: 12)
        editLabel.backgroundColor = .darkBlueGray2
        editLabel.layer.cornerRadius = 10
        editLabel.layer.borderColor = UIColor.white.cgColor
        editLabel.layer.borderWidth = 1
        editLabel.layer.masksToBounds = true

        let usersLayout = UICollectionViewFlowLayout()
        usersLayout.minimumInteritemSpacing = cellSpacing

        usersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: usersLayout)
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = self
        usersCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: usersCellReuseIdentifier)
        usersCollectionView.backgroundColor = .none
        addSubview(usersCollectionView)

        if isEdit{
            addSubview(editLabel)
        }

        setupConstraints()
    }

    private func setupConstraints() {
        let editLabelSize = CGSize(width: 35, height: 20)

        usersCollectionView.snp.makeConstraints { make in
            if isEdit {
                make.top.bottom.leading.equalToSuperview()
                make.trailing.equalTo(editLabel.snp.leading).offset(-cellSpacing)
            } else {
                make.edges.equalToSuperview()
            }
        }
        if isEdit {
            editLabel.snp.makeConstraints { make in
                make.top.bottom.trailing.equalToSuperview()
                make.size.equalTo(editLabelSize)
            }
        }
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
        cell.backgroundColor = .deepPurple
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 0.625
        cell.layer.cornerRadius = 10
        let cellImage = indexPath.item == usersPreview.count ? "ellipsis" : "temp"
        // Note: Ellipsis image seems low quality
        cell.backgroundView = UIImageView(image: UIImage(named: cellImage))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

}
