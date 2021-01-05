//
//  MediaInListCollectionViewCell.swift
//  Flick
//
//  Created by HAIYING WENG on 5/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import SkeletonView
import UIKit

class MediaInListCollectionViewCell: UICollectionViewCell {

    let mediaImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.masksToBounds = true
        backgroundColor = .lightGray3
        isSkeletonable = true
        layer.cornerRadius = 8
        contentView.layer.cornerRadius = 8
        contentView.isSkeletonable = true
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
        
//        mediaImageView.layer.cornerRadius = 8
        contentView.addSubview(mediaImageView)
        
        mediaImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(media: SimpleMedia) {
        if let pictureUrl = URL(string: media.posterPic ?? ""), let pictureData = try? Data(contentsOf: pictureUrl) {
            let pictureObject = UIImage(data: pictureData)
            mediaImageView.image = pictureObject
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
