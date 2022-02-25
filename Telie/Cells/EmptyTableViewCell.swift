//
//  EmptyTableViewCell.swift
//  Telie
//
//  Created by Haiying W on 2/25/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let containerView = UIView()

    // MARK: - Data Vars
    static let reuseIdentifier = "EmptyCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        contentView.backgroundColor = .white
        contentView.addSubview(containerView)

        containerView.snp.makeConstraints { make in
            make.height.equalTo(160)
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
