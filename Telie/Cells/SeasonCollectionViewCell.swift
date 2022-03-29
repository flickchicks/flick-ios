//
//  SeasonCollectionViewCell.swift
//  Telie
//
//  Created by Alanna Zhou on 3/5/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class SeasonCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private View Vars
    private let seasonLabel = UILabel()
  
    // MARK: - Data Vars
    static let reuseIdentifier = "SeasonCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        isSelected = false
        seasonLabel.textColor = .darkBlueGray2
        seasonLabel.textAlignment = .center
        seasonLabel.font = .systemFont(ofSize: 14, weight: .medium)
        seasonLabel.backgroundColor = .lightGray2
        seasonLabel.layer.borderColor = UIColor.darkBlueGray2.cgColor
        seasonLabel.layer.borderWidth = 1
        seasonLabel.layer.cornerRadius = 13
        seasonLabel.layer.masksToBounds = true
        contentView.addSubview(seasonLabel)

        setupConstraints()
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                seasonLabel.textColor = .darkPurple
                seasonLabel.backgroundColor = .lightPurple
                seasonLabel.layer.borderColor = UIColor.darkPurple.cgColor
            } else {
                seasonLabel.textColor = .darkBlueGray2
                seasonLabel.backgroundColor = .lightGray2
                seasonLabel.layer.borderColor = UIColor.darkBlueGray2.cgColor
            }
        }
    }
    
    private func setupConstraints() {
        seasonLabel.snp.makeConstraints { make in
            make.height.equalTo(26)
            make.width.equalTo(78)
        }
    }

    func configure(seasonNumber: Int) {
        seasonLabel.text = "Season \(seasonNumber)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
