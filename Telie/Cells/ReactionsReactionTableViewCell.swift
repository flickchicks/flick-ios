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
    private let episodeLabel = UILabel()

    // MARK: - Data Vars
    static let reuseIdentifier = "ReactionsReactionTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        episodeLabel.textColor = .darkPurple
        episodeLabel.textAlignment = .left
        episodeLabel.font = .systemFont(ofSize: 16, weight: .medium)
        episodeLabel.backgroundColor = .clear
        episodeLabel.layer.cornerRadius = 8
        episodeLabel.layer.masksToBounds = true
        contentView.addSubview(episodeLabel)

        setupConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        episodeLabel.backgroundColor = selected ?  .lightGray2 : .clear
    }

    func configure(reactionName: String) {
        episodeLabel.text = "    \(reactionName)"
     
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        episodeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }

    }


}

