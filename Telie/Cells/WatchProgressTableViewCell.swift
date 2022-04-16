//
//  WatchProgressTableViewCell.swift
//  Telie
//
//  Created by Alanna Zhou on 4/16/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class WatchProgressTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let seasonLabel = UILabel()

    // MARK: - Data Vars
    static let reuseIdentifier = "WatchProgressTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        seasonLabel.textColor = .darkBlue
        seasonLabel.textAlignment = .left
        seasonLabel.font = .systemFont(ofSize: 16, weight: .medium)
        seasonLabel.backgroundColor = .clear
        seasonLabel.layer.cornerRadius = 8
        seasonLabel.layer.masksToBounds = true
        contentView.addSubview(seasonLabel)

        setupConstraints()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        seasonLabel.backgroundColor = selected ?  .lightGray2 : .clear
    }

    func configure(seasonName: String) {
        seasonLabel.text = "    \(seasonName)"
     
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        seasonLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(35)
        }

    }


}

