//
//  LoginButton.swift
//  Flick
//
//  Created by Haiying W on 1/14/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

enum LoginButtonType: String {
    case apple = "Apple"
    case facebook = "Facebook"

    var backgroundColor: UIColor {
        switch self {
        case .apple:
            return .black
        case .facebook:
            return .facebookBlue
        }
    }

    var iconImageName: String {
        switch self {
        case .apple:
            return "appleIcon"
        case .facebook:
            return "facebookIcon"
        }
    }

    var iconSize: CGSize {
        switch self {
        case .apple:
            return CGSize(width: 48, height: 48)
        case .facebook:
            return CGSize(width: 30, height: 30)
        }
    }
}

class LoginButton: UIButton {

    private let iconImageView = UIImageView()
    private let label = UILabel()

    init(type: LoginButtonType) {
        super.init(frame: .zero)
        self.backgroundColor = type.backgroundColor
        clipsToBounds = true
        layer.cornerRadius = 23

        iconImageView.image = UIImage(named: type.iconImageName)
        addSubview(iconImageView)

        label.attributedText =
            NSMutableAttributedString()
            .whiteNormalFont14("Continue with ")
            .whiteBoldFont14(type.rawValue)
        label.textAlignment = .center
        addSubview(label)

        iconImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.leading).offset(35)
            make.centerY.equalToSuperview()
            make.size.equalTo(type.iconSize)
        }

        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(50)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
