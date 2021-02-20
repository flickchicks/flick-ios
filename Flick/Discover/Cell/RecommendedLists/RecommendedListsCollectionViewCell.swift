//
//  RecommendedListsCollectionViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 2/20/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class RecommendedListsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private View Variables
    private let img1imageView = UIImageView()
    private let img2imageView = UIImageView()
    private let img3imageView = UIImageView()
    private let userImageView = UIImageView()
    private let detailLabel = UILabel()
    private var mediaId: Int!
    
    static let reuseIdentifier = "RecommendedListsCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        img1imageView.layer.cornerRadius = 12
        img1imageView.clipsToBounds = true
        img1imageView.layer.masksToBounds = true
        img1imageView.contentMode = .scaleAspectFill
        img1imageView.layer.backgroundColor = UIColor.mediumGray.cgColor
        contentView.addSubview(img1imageView)
        
        img2imageView.layer.cornerRadius = 12
        img2imageView.clipsToBounds = true
        img2imageView.layer.masksToBounds = true
        img2imageView.contentMode = .scaleAspectFill
        img2imageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor

        contentView.addSubview(img2imageView)
        
        img3imageView.layer.cornerRadius = 12
        img3imageView.clipsToBounds = true
        img3imageView.layer.masksToBounds = true
        img3imageView.contentMode = .scaleAspectFill
        img3imageView.layer.backgroundColor = UIColor.lightGray.cgColor

        contentView.addSubview(img3imageView)
        
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = 10
        userImageView.layer.borderWidth = 1.5
        userImageView.layer.borderColor = UIColor.movieWhite.cgColor
        userImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        contentView.addSubview(userImageView)
        
        detailLabel.text = "Saved by Lucy"
        detailLabel.font = .boldSystemFont(ofSize: 14)
        detailLabel.textColor = .darkBlueGray2
        contentView.addSubview(detailLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        img1imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 312, height: 468))
            make.top.trailing.equalToSuperview()
        }
        
        img2imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 312, height: 468))
            make.top.trailing.equalTo(img1imageView).inset(10)
        }
        
        img3imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 312, height: 468))
            make.top.trailing.equalTo(img2imageView).inset(10)
        }
        
        userImageView.snp.makeConstraints { make in
            make.leading.equalTo(img3imageView)
            make.top.equalTo(img3imageView.snp.bottom).offset(8)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        detailLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.centerY.equalTo(userImageView)
            make.height.equalTo(17)
            make.trailing.equalToSuperview()
        }
    
    }
    
    func configure(with media: SimpleMedia) {
        mediaId = media.id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        img1imageView.image = nil
        img2imageView.image = nil
        img3imageView.image = nil
    }

}
