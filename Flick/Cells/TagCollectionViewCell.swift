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
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .lightPurple
                layer.borderWidth = 1
                layer.borderColor = UIColor.darkPurple.cgColor
            } else {
                backgroundColor = .white
                layer.borderWidth = 0
            }
        }
    }

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
