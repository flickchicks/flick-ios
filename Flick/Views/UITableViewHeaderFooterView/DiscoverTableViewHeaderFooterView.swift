//
//  DiscoverTableViewHeaderFooterView.swift
//  Flick
//
//  Created by Lucy Xu on 12/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SkeletonView

class DiscoverTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    private let titleLabel = UILabel()
    static let reuseIdentifier = "DiscoverHeaderViewReuseIdentifier"

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        
        titleLabel.textColor = .darkBlueGray2
        titleLabel.font = .boldSystemFont(ofSize: 12)
        contentView.addSubview(titleLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
}
