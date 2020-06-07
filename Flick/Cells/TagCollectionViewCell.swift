//
//  TagCollectionViewCell.swift
//  Flick
//
//  Created by HAIYING WENG on 6/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    private let tagLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        clipsToBounds = false
        layer.cornerRadius = 12
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        
        tagLabel.textColor = .darkPurple
        tagLabel.textAlignment = .center
        tagLabel.font = .systemFont(ofSize: 12)
        tagLabel.preferredMaxLayoutWidth = 120
        tagLabel.numberOfLines = 0
        contentView.addSubview(tagLabel)
        
        tagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(for tag: String) {
        tagLabel.text = tag
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
