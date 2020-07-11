//
//  MediaTagCollectionViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import UIKit

class MediaTagCollectionViewCell: UICollectionViewCell {

    private let tagLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        layer.cornerRadius = 12
        backgroundColor = .lightGray2

        tagLabel.textAlignment = .center
        tagLabel.font = .systemFont(ofSize: 12)
        tagLabel.preferredMaxLayoutWidth = 120
        tagLabel.numberOfLines = 0
        tagLabel.textColor = .darkBlueGray2
        contentView.addSubview(tagLabel)

        tagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(with text: String) {
        tagLabel.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
