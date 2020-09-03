//
//  DiscoverSearchVCCollectionViewCell.swift
//  Flick
//
//  Created by Haiying W on 9/3/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class DiscoverSearchVCCollectionViewCell: UICollectionViewCell {

    // MARK: - Public View Vars
    let viewController = DiscoverSearchResultViewController()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(viewController.view)

        viewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(searchType: SearchTab) {
        viewController.searchType = searchType
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
