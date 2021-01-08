//
//  UserPreviewCollectionViewCell.swift
//  Flick
//
//  Created by Haiying W on 1/6/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class UserPreviewCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let profileImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .deepPurple
        clipsToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 10

        contentView.addSubview(profileImageView)

        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(user: UserProfile?, shouldShowEllipsis: Bool) {
        if shouldShowEllipsis {
            profileImageView.image = UIImage(named: "ellipsis")
        } else {
            if let user = user,
               let pictureUrl = URL(string: user.profilePic?.assetUrls.small ?? "") {
                profileImageView.kf.setImage(with: pictureUrl)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

}