//
//  RoundTopView.swift
//  Flick
//
//  Created by HAIYING WENG on 5/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class RoundTopView: UIView {

    init(hasShadow: Bool) {
        super.init(frame: .zero)

        backgroundColor = .white
        clipsToBounds = false
        layer.cornerRadius = 50
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        if hasShadow {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: -4)
            layer.shadowOpacity = 0.1
            layer.shadowRadius = 8
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
