//
//  EpisodeTableViewCell.swift
//  Telie
//
//  Created by Alanna Zhou on 3/5/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class ReactionsReactionTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let profileImageView = UIImageView()
    private let reactionNameLabel = UILabel()
    private let reactionContentLabel = PaddingLabel()
    private let timeSinceLabel = UILabel()

    // MARK: - Data Vars
    static let reuseIdentifier = "ReactionsReactionTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        profileImageView.kf.setImage(with: URL(string: Constants.User.defaultImage))
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.movieWhite.cgColor
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        contentView.addSubview(profileImageView)
        
        
        reactionNameLabel.textColor = .black
        reactionNameLabel.textAlignment = .left
        reactionNameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        reactionNameLabel.backgroundColor = .clear
        reactionNameLabel.layer.cornerRadius = 8
        reactionNameLabel.layer.masksToBounds = true
        contentView.addSubview(reactionNameLabel)
        
        timeSinceLabel.textColor = .mediumGray
        timeSinceLabel.textAlignment = .right
        timeSinceLabel.font = .systemFont(ofSize: 12, weight: .light)
        timeSinceLabel.backgroundColor = .clear
        contentView.addSubview(timeSinceLabel)
        
        reactionContentLabel.textColor = .black
        reactionContentLabel.textAlignment = .left
        reactionContentLabel.font = .systemFont(ofSize: 16, weight: .medium)
        reactionContentLabel.backgroundColor = .white
        reactionContentLabel.layer.cornerRadius = 8
        reactionContentLabel.layer.masksToBounds = true
        
   
        reactionContentLabel.paddingLeft = 15
        reactionContentLabel.paddingRight = 15
        reactionContentLabel.paddingTop = 10
        reactionContentLabel.paddingBottom = 10
        reactionContentLabel.numberOfLines = 0

        contentView.addSubview(reactionContentLabel)


        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.kf.setImage(with: URL(string: Constants.User.defaultImage))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        reactionNameLabel.backgroundColor = selected ?  .lightGray2 : .clear
    }

    func configure(reactionName: String, reactionProfilePic: String, reactionContent: String, timeSince: String) {
        reactionNameLabel.text = "    \(reactionName)"
        reactionContentLabel.text = reactionContent
        
       let imageUrl = URL(string: reactionProfilePic)
        profileImageView.kf.setImage(with: imageUrl)
        timeSinceLabel.text = timeSince
    }
    


    private func setupConstraints() {
        let verticalPadding: CGFloat = 11
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(CGSize(width: 40, height: 40))
//            make.top.centerX.equalToSuperview()
        }
        
        reactionNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView).inset(30)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(profileImageView)
            make.height.equalTo(35)
        }
        
        timeSinceLabel.snp.makeConstraints { make in
//            make.leading.equalTo(profileImageView).inset(30)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(12)
            make.centerY.equalTo(reactionNameLabel)
        }
        
        reactionContentLabel.snp.makeConstraints { make in
            make.top.equalTo(reactionNameLabel.snp.bottom).offset(verticalPadding)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }

    }

  



}