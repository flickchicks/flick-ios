//
//  SearchTabCollectionViewCell.swift
//  Flick
//
//  Created by Haiying W on 8/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum SearchTab: String {
    case lists = "Lists"
    case movies = "Movies"
    case people = "People"
    case shows = "Shows"
    case tags = "Tags"
    case top = "Top"
}

class SearchTabCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let activeTabIndicatorView = UIView()
    private let tabLabel = UILabel()

    // MARK: - Private Data Vars
    private let activeTabIndicatorViewSize = CGSize(width: 4, height: 4)

    override var isSelected: Bool {
        didSet {
            activeTabIndicatorView.isHidden = !isSelected
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        tabLabel.textColor = .darkBlue
        tabLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(tabLabel)

        activeTabIndicatorView.isHidden = true
        activeTabIndicatorView.backgroundColor = .darkBlue
        activeTabIndicatorView.layer.cornerRadius = activeTabIndicatorViewSize.width / 2
        contentView.addSubview(activeTabIndicatorView)

        setupConstraints()
    }

    private func setupConstraints() {
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
