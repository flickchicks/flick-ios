//
//  TagCollectionViewCell.swift
//  Flick
//
//  Created by HAIYING WENG on 6/13/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum TagType { case tag, more }

class TagCollectionViewCell: UICollectionViewCell {
    
    private let tagLabel = UILabel()
    var type: TagType!
    
    override var isSelected: Bool {
        didSet {
            if self.type == .tag {
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
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        layer.cornerRadius = 12

        tagLabel.textAlignment = .center
        tagLabel.font = .systemFont(ofSize: 12)
        tagLabel.preferredMaxLayoutWidth = 120
        tagLabel.numberOfLines = 0
        contentView.addSubview(tagLabel)
        
        tagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(for text: String, type: TagType) {
        self.type = type
        switch type {
        case .tag:
            backgroundColor = .white
            tagLabel.textColor = .darkPurple
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowOpacity = 0.1
            layer.shadowRadius = 4
        case .more:
            backgroundColor = .clear
            tagLabel.textColor = .mediumGray
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = .zero
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
        }
        tagLabel.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
