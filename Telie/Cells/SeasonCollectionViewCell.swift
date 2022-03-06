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
        seasonLabel.textColor = .darkPurple
        seasonLabel.textAlignment = .center
        seasonLabel.font = .systemFont(ofSize: 14, weight: .medium)
        seasonLabel.backgroundColor = .clear // .lightPurple
        seasonLabel.layer.borderColor = UIColor.darkPurple.cgColor
        seasonLabel.layer.borderWidth = 1
        seasonLabel.layer.cornerRadius = 13
        seasonLabel.layer.masksToBounds = true
        contentView.addSubview(seasonLabel)

        setupConstraints()
    }

    override var isSelected: Bool {
        didSet {
            seasonLabel.backgroundColor = isSelected ? .lightPurple : .clear
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
