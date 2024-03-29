//
//  TabOptionCollectionViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import SnapKit
import UIKit

class TabOptionCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let activeTabIndicatorView = UIView()
    private let tabLabel = UILabel()

    // MARK: - Private Data Vars
    private var activeCellColor: UIColor = .darkBlue
    private var inactiveCellColor: UIColor = .mediumGray
    
    static let reuseIdentifier = "tabOptionCellReuseIdentifier"

    override var isSelected: Bool {
        didSet {
            activeTabIndicatorView.isHidden = !isSelected
            tabLabel.textColor = isSelected ? activeCellColor : inactiveCellColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        // TODO: Fix styling of views
        tabLabel.textColor = inactiveCellColor
        tabLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(tabLabel)

        tabLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tabText: String) {
        tabLabel.text = tabText
    }
}
