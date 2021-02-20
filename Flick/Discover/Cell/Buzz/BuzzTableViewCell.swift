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
    private let commentTextView = UITextView()
    private let dateLabel = UILabel()
    private let summaryView = UIView()
    private let mediaImageView = UIImageView()
    private let mediaTitleLabel = UILabel()
    private let mediaDescriptionLabel = UILabel()
    
    static let reuseIdentifier = "BuzzTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
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
        buzzLabel.numberOfLines = 0
        buzzLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(buzzLabel)
        
        dateLabel.text = "4d"
        dateLabel.textColor = .mediumGray
        dateLabel.font = .systemFont(ofSize: 10)
        contentView.addSubview(dateLabel)
        
        summaryView.layer.cornerRadius = 12
        summaryView.layer.backgroundColor = UIColor.movieWhite.cgColor
        contentView.addSubview(summaryView)
        
        commentTextView.text = "This was indeed amazing!"
        commentTextView.isEditable = false
        commentTextView.isScrollEnabled = false
        commentTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        commentTextView.layer.backgroundColor = UIColor.lightGray2.cgColor
        commentTextView.font = .systemFont(ofSize: 14)
        commentTextView.textColor = .darkBlue
        commentTextView.layer.cornerRadius = 12
        contentView.addSubview(commentTextView)
        
        mediaImageView.contentMode = .scaleAspectFill
        mediaImageView.layer.masksToBounds = true
        mediaImageView.clipsToBounds = true
        mediaImageView.layer.cornerRadius = 8
        mediaImageView.layer.backgroundColor = UIColor.darkBlueGray2.cgColor
        summaryView.addSubview(mediaImageView)
        
        mediaTitleLabel.text = "Start Up"
        mediaTitleLabel.textColor = .darkBlue
        mediaTitleLabel.numberOfLines = 0
        mediaTitleLabel.font = .systemFont(ofSize: 14)
        summaryView.addSubview(mediaTitleLabel)
        
        mediaDescriptionLabel.text = "Nam Do-San is the founder of Samsan Tech. He is excellent with mathematics. He started Samsan Tech two years ago, but the company is not doing well. Somehow, Nam Do-San becomes Seo Dal-Mi’s first love. They cheer each others start and growth."
        mediaDescriptionLabel.textColor = .darkBlue
        mediaDescriptionLabel.numberOfLines = 0
        mediaDescriptionLabel.font = .systemFont(ofSize: 10)
        summaryView.addSubview(mediaDescriptionLabel)
        
        setupConstraints()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(23)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(23)
            make.centerY.equalTo(buzzLabel)
            make.width.equalTo(22)
        }
        
        buzzLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalTo(dateLabel.snp.leading).inset(12)
            make.height.equalTo(17)
        }
        
        summaryView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 271, height: 122))
            make.leading.equalTo(commentTextView)
            make.top.equalTo(commentTextView.snp.bottom).inset(7)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.leading.equalTo(buzzLabel)
            make.trailing.equalTo(dateLabel.snp.leading)
            make.top.equalTo(profileImageView.snp.bottom)
        }
        
        mediaImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 90))
            make.leading.bottom.equalToSuperview().inset(12)
        }
        
        mediaTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(mediaImageView.snp.trailing).offset(12)
            make.top.equalTo(mediaImageView.snp.top).offset(3)
            make.trailing.equalToSuperview().inset(12)
        }
        
        mediaDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(mediaTitleLabel)
            make.top.equalTo(mediaTitleLabel.snp.bottom).offset(8)
            make.bottom.equalTo(mediaImageView)
        }
        
    }
    
}
