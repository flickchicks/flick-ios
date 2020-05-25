//
//  MediaInListCollectionViewCell.swift
//  Flick
//
//  Created by HAIYING WENG on 5/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import SnapKit
import UIKit

class MediaInListCollectionViewCell: UICollectionViewCell {
    
    let mediaImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 8
        backgroundColor = .lightGray

        contentView.addSubview(mediaImageView)
        mediaImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
