//
//  SeasonCollectionViewCell.swift
//  Telie
//
//  Created by Alanna Zhou on 3/5/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class SeasonCollectionViewCell: UICollectionViewCell {
    
    private let seasonLabel = UILabel()
  

    static let reuseIdentifier = "SeasonCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

      

        seasonLabel.textColor = .darkBlue
        seasonLabel.textAlignment = .center
        seasonLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(seasonLabel)

        setupConstraints()
    }

    private func setupConstraints() {
      
        seasonLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }

      
    }

    func configure(seasonNumber: Int) {
        seasonLabel.text = "Season \(seasonNumber)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
