//
//  TrendingContentCollectionViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 12/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SkeletonView

class TrendingContentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private View Variables
    private let imageView = UIImageView()
//    private let saveButton = UIButton()
//    private let shareButton = UIButton()
    private var mediaId: Int!
    
    static let reuseIdentifier = "TrendingContentCellReuseIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        isSkeletonable = true
        
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isSkeletonable = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    
    }
    
    func configure(with media: SimpleMedia) {
        mediaId = media.id
        if let posterPic = media.posterPic, let imageUrl = URL(string: posterPic) {
            imageView.kf.setImage(with: imageUrl)
        } else {
            imageView.image = UIImage(named: "defaultMovie")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

}
