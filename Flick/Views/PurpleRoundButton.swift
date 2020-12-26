//
//  PurpleRoundButton.swift
//  Flick
//
//  Created by Haiying W on 12/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class PurpleRoundButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        setTitleColor(.gradientPurple, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14)
        layer.cornerRadius = 20
        layer.backgroundColor = UIColor.lightPurple.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
