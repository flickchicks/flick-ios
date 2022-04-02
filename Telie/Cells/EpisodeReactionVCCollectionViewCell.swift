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
    var viewController: EpisodeReactionViewController!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func configure(vc: EpisodeReactionViewController) {
        viewController = vc
        contentView.addSubview(viewController.view) // TODO: might be bad to do this, can come back to it
        viewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        viewController.view.removeFromSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
