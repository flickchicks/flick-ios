//
//  ProviderCollectionViewCell.swift
//  Flick
//
//  Created by Haiying W on 1/10/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class ProviderCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let providerImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        layer.cornerRadius = 5
        layer.backgroundColor = UIColor.gray.cgColor

        contentView.addSubview(providerImageView)

        providerImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(for provider: Provider) {
        let imageUrl = URL(string: provider.image)
        providerImageView.kf.setImage(with: imageUrl)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
