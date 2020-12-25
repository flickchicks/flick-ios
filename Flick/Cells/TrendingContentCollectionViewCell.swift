//
//  TrendingContentCollectionViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 12/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class TrendingContentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private View Variables
    private let imageView = UIImageView()
    private let saveButton = UIButton()
    private let shareButton = UIButton()
    
    static let reuseIdentifier = "TrendingContentCellReuseIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        shareButton.setImage(UIImage(named: "shareButton"), for: .normal)
        contentView.addSubview(shareButton)
        
        saveButton.setImage(UIImage(named: "saveButton"), for: .normal)
        contentView.addSubview(saveButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.trailing.equalTo(imageView).inset(12)
            make.centerY.equalTo(imageView.snp.bottom)
        }
        
        shareButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.trailing.equalTo(saveButton.snp.leading).offset(-12)
            make.centerY.equalTo(saveButton)
        }
        
    }
    
    func configure(with media: DiscoverMedia) {
        if let imageUrl = URL(string: media.posterPic) {
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
