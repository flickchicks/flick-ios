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

    private let mediaImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray3
        isSkeletonable = true
        
        layer.cornerRadius = 8
        clipsToBounds = true
        layer.masksToBounds = true
        
        mediaImageView.contentMode = .scaleAspectFill
        mediaImageView.layer.cornerRadius = 8
        mediaImageView.layer.masksToBounds = true
        mediaImageView.clipsToBounds = true
        mediaImageView.contentMode = .scaleAspectFill
        mediaImageView.isSkeletonable = true
        contentView.addSubview(mediaImageView)
        
        mediaImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(media: SimpleMedia) {
        if let posterPic = media.posterPic, let imageUrl = URL(string: posterPic) {
            mediaImageView.kf.setImage(with: imageUrl)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        mediaImageView.image = nil
    }

}
