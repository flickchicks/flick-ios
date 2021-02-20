//
//  BuzzTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 2/19/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class BuzzTableViewCell: UITableViewCell {
    
    private let profileImageView = UIImageView()
    private let buzzLabel = UILabel()
    private let commentLabel = UILabel()
    private let dateLabel = UILabel()
    private let summaryView = UIView()
    private let mediaImageView = UIImageView()
    private let mediaTitleLabel = UILabel()
    private let mediaDescriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.movieWhite.cgColor
        profileImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        contentView.addSubview(profileImageView)
        
        buzzLabel.text = "Lucy commented..."
        buzzLabel.textColor = .darkBlue
        buzzLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(buzzLabel)
        
        commentLabel.text = "This was indeed amazing!"
        commentLabel.textColor = .darkBlue
        commentLabel.font = .systemFont(ofSize: 14)
        commentLabel.layer.backgroundColor = UIColor.movieWhite.cgColor
        contentView.addSubview(commentLabel)
        
        dateLabel.text = "4d"
        dateLabel.textColor = .mediumGray
        dateLabel.font = .systemFont(ofSize: 10)
        contentView.addSubview(dateLabel)
        
        setupConstraints()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(23)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(23)
            make.centerY.equalTo(buzzLabel)
            make.width.equalTo(22)
        }
        
    }
    
}
