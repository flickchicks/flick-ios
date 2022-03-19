//
//  EpisodeReactionCollectionViewCell.swift
//  Telie
//
//  Created by Alanna Zhou on 3/18/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class EpisodeReactionVCCollectionViewCell: UICollectionViewCell {
    // MARK: - Public View Vars
    var viewController = EpisodeReactionViewController()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(viewController.view)

        viewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure() {
        print("configure called")
//        viewController.searchType = searchType
    }

    override func prepareForReuse() {
        print("prepare for reuse called")
//        viewController.clearContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
