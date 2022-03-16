//
//  ReactionCollectionViewCell.swift
//  Telie
//
//  Created by Haiying W on 3/15/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class ReactionCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let containerView = UIView()

    static let cellReuseIdentitifer = "ReactionCollectionViewCellReuseIdentifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .offWhite

        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10
        containerView.layer.backgroundColor = UIColor.white.cgColor
        contentView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func configure() {

    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        providerImageView.image = nil
    }
    
}
