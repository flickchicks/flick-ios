//
//  DiscoverContentCell.swift
//  Flick
//
//  Created by Lucy Xu on 12/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class DiscoverContentCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let shareButton = UIButton()
    private let saveButton = UIButton()
    
    static let reuseIdentifier = "DiscoverContentCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        shareButton.setImage(UIImage(named: "saveButton"), for: .normal)
        addSubview(shareButton)
        
        saveButton.setImage(UIImage(named: "saveButton"), for: .normal)
        addSubview(saveButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.trailing.equalTo(imageView).inset(12)
            make.centerY.equalTo(imageView.snp.bottom)
        }
        
        shareButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.trailing.equalTo(saveButton.snp.leading).offset(-12)
            make.centerY.equalTo(saveButton)
        }
        
    }
    
    func configure(with media: DiscoverMedia) {
        print(media.posterPic)
        if let imageUrl = URL(string: media.posterPic) {
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
