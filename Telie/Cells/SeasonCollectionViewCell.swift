//
//  SeasonCollectionViewCell.swift
//  Telie
//
//  Created by Alanna Zhou on 3/5/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

//seasonButton.setTitle("Season 1", for: .normal)
//seasonButton.setTitleColor(.darkPurple, for: .normal)
//seasonButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
//seasonButton.backgroundColor = .lightPurple
//seasonButton.layer.borderColor = UIColor.darkPurple.cgColor
//seasonButton.layer.borderWidth = 1
//seasonButton.layer.cornerRadius = 13
//view.addSubview(seasonButton)
//
//season2Button.setTitle("Season 2", for: .normal)
//season2Button.setTitleColor(.darkPurple, for: .normal)
//season2Button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
//season2Button.backgroundColor = .none
//season2Button.layer.borderColor = UIColor.darkPurple.cgColor
//season2Button.layer.borderWidth = 1
//season2Button.layer.cornerRadius = 13
//view.addSubview(season2Button)

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
