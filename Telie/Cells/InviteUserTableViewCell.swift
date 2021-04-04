//
//  InviteUserTableViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 4/3/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit
import Kingfisher

class InviteUserTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let nameLabel = UILabel()
    private let userImageView = UIImageView()
    private let usernameLabel = UILabel()

    private let inviteSearchBar = SearchBar()

    // MARK: - Data Vars
    static let reuseIdentifier = "InviteUserCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        inviteSearchBar.placeholder = "Search friends"
//        inviteSearchBar.delegate = self
        contentView.addSubview(inviteSearchBar)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with delegate: UISearchBarDelegate) {
        inviteSearchBar.delegate = delegate
    }

    private func setupConstraints() {
//        let userImageSize = CGSize(width: 40, height: 40)
//
//        userImageView.snp.makeConstraints { make in
//            make.size.equalTo(userImageSize)
//            make.centerY.leading.equalToSuperview()
//        }
//
//        nameLabel.snp.makeConstraints { make in
//            make.leading.equalTo(userImageView.snp.trailing).offset(12)
//            make.top.equalTo(userImageView)
//            make.trailing.equalToSuperview().inset(12)
//        }
//
//        usernameLabel.snp.makeConstraints { make in
//            make.leading.equalTo(nameLabel)
//            make.top.equalTo(nameLabel.snp.bottom).offset(4)
//        }

        inviteSearchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(12)
        }
    }

}

//extension InviteUserTableViewCell: UISearchBarDelegate {
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
////        let searchVC = DiscoverSearchViewController()
////        navigationController?.pushViewController(searchVC, animated: true)
//        return false
//    }
//}
