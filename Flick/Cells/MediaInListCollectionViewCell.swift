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
        clipsToBounds = true
        layer.cornerRadius = 8
        backgroundColor = .lightGray3

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

    override func prepareForReuse() {
        super.prepareForReuse()
        mediaImageView.image = nil
    }

}
