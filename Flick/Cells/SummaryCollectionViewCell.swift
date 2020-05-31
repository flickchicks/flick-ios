//
//  SummaryCollectionViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 5/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import SnapKit
import UIKit

class SummaryCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let numberLabel = UILabel()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let numberLabelSize = CGSize(width: 12, height: 22)
    private let titleLabelSize = CGSize(width: 66, height: 15)

    override init(frame: CGRect) {
        super.init(frame: frame)

//        backgroundColor = .blue

        numberLabel.textColor = .mediumGray
        numberLabel.font = .boldSystemFont(ofSize: 18)
        addSubview(numberLabel)

        titleLabel.textColor = .mediumGray
        titleLabel.textAlignment = .center
//        titleLabel.backgroundColor = .cyan
        titleLabel.font = .systemFont(ofSize: 15)
        addSubview(titleLabel)

        numberLabel.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.size.equalTo(numberLabelSize)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.size.equalTo(titleLabelSize)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with summary: ActivitySummary) {
        numberLabel.text = "\(summary.count)"
        titleLabel.text = summary.title
    }
}
