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
    private var cellSpacing: CGFloat
    private let editLabelSize = CGSize(width: 35, height: 20)
    private var hasEdit: Bool = false
    private var modeCellSpacing: [UsersLayoutMode : CGFloat] = [
        .friends : -8,
        .collaborators : -5
    ]
    private let numMaxUsers = 6
    private var usersLayoutMode: UsersLayoutMode
    private let usersCellReuseIdentifier = "UsersCellReuseIdentifier"

    var users: [UserProfile] = [] {
        didSet {
            usersCollectionView.reloadData()
        }
    }

    init(users: [UserProfile], usersLayoutMode : UsersLayoutMode, hasEdit: Bool = false) {
        self.users = users
        self.cellSpacing = modeCellSpacing[usersLayoutMode] ?? -5
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

        usersCollectionView = UICollect ionView(frame: .zero, collectionViewLayout: usersLayout)
        usersCollectionView.delegate = self
        usersCollectionView.dataSource = self
        usersCollectionView.register(UserPreviewCollectionViewCell.self, forCellWithReuseIdentifier: usersCellReuseIdentifier)
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

        editLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.size.equalTo(editLabelSize)
        }
        
        usersCollectionView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalTo(editLabel.snp.leading).offset(-cellSpacing)
        }
    }

    // Get number of users to show including ellipsis
    private func getNumUsers() -> Int {
        switch usersLayoutMode {
        case .collaborators:
             return min(users.count, numMaxUsers + 1)
        case .friends:
            return users.count == 0 ? 0 : min(users.count, numMaxUsers) + 1
        }
    }

    func getUsersPreviewWidth() -> CGFloat {
        let numUsers = getNumUsers()
        let fullUsersWidth = numUsers * 20
        let overlapUsersWidth = (numUsers - 1) * Int(cellSpacing) * -1
        var usersPreviewWidth = CGFloat(fullUsersWidth - overlapUsersWidth)
        if hasEdit {
            usersPreviewWidth += editLabelSize.width
        }
        return usersPreviewWidth
    }
}

extension UsersPreviewView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Always want to render the ellipsis for friends view but only do it for collaborators view if user count exceeds max
        return getNumUsers()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: usersCellReuseIdentifier, for: indexPath) as? UserPreviewCollectionViewCell else { return UICollectionViewCell() }

        var shouldShowEllipsis: Bool {
            switch usersLayoutMode {
            case .collaborators:
                return indexPath.item == numMaxUsers
            case .friends:
                return indexPath.item == getNumUsers() - 1
            }
        }

        if shouldShowEllipsis {
            cell.configure(user: nil, shouldShowEllipsis: true)
        } else {
            cell.configure(user: users[indexPath.row], shouldShowEllipsis: false)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

}
