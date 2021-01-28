//
//  RoundedButton.swift
//  Flick
//
//  Created by Haiying W on 12/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum RoundedButtonStyle { case gray, purple }

class RoundedButton: UIButton {

    init(style: RoundedButtonStyle, title: String) {
        super.init(frame: .zero)

        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        layer.cornerRadius = 20
        layer.borderWidth = 1
        switch style {
        case .gray:
            setTitleColor(.darkBlueGray2, for: .normal)
            layer.backgroundColor = UIColor.lightGray2.cgColor
            layer.borderColor = UIColor.darkBlueGray2.cgColor
        case .purple:
            setTitleColor(.gradientPurple, for: .normal)
            layer.backgroundColor = UIColor.lightPurple.cgColor
            layer.borderColor = UIColor.gradientPurple.cgColor
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
