//
//  ListNameTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 8/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class ListNameTableViewCell: UITableViewCell {

    private let selectIndicator = SelectIndicatorView(width: 20)
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
