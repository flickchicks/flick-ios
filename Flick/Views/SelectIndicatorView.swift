//
//  SelectIndicatorView.swift
//  Flick
//
//  Created by Haiying W on 7/1/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class SelectIndicatorView: UIView {

    init(width: CGFloat) {
        super.init(frame: .zero)

        backgroundColor = .clear
        layer.cornerRadius = width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
    }

    func select() {
        layer.borderColor = UIColor.gradientPurple.cgColor
    }

    func deselect() {
        layer.borderColor = UIColor.lightGray.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
