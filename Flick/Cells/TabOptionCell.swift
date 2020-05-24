//
//  TabOptionCell.swift
//  Flick
//
//  Created by Lucy Xu on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import SnapKit
import UIKit

class TabOptionCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let tabLabel = UILabel()
    private let activeTabIndicatorView = UIView()

    // MARK: - Private Data Vars
    private let activeTabIndicatorViewSize = CGSize(width: 8, height: 8)
    private var activeCellColor: UIColor = .colorFromCode(0x2B25A6)
    private var inactiveCellColor: UIColor = .colorFromCode(0x6E6E87)

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
        addSubview(tabLabel)

        activeTabIndicatorView.isHidden = true
        activeTabIndicatorView.backgroundColor = activeCellColor
        activeTabIndicatorView.layer.cornerRadius = activeTabIndicatorViewSize.width / 2
        addSubview(activeTabIndicatorView)

        tabLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        activeTabIndicatorView.snp.makeConstraints { make in
            make.top.equalTo(tabLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.size.equalTo(activeTabIndicatorViewSize)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with tabText: String) {
        tabLabel.text = tabText
    }
}
