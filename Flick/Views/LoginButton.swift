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
}

class LoginButton: UIButton {

    private let iconImageView = UIImageView()
    private let label = UILabel()

    init(type: LoginButtonType, backgroundColor: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        clipsToBounds = true
        layer.cornerRadius = 23

        var iconImageName: String {
            switch type {
            case .apple:
                return "appleIcon"
            case .facebook:
                return "facebookIcon"
            }
        }
        iconImageView.image = UIImage(named: iconImageName)
        addSubview(iconImageView)

        label.attributedText =
            NSMutableAttributedString()
            .whiteNormalFont14("Continue with ")
            .whiteBoldFont14(type.rawValue)
        label.textAlignment = .center
        addSubview(label)

        var iconSize: CGSize {
            switch type {
            case .apple:
                return CGSize(width: 48, height: 48)
            case .facebook:
                return CGSize(width: 30, height: 30)
            }
        }

        iconImageView.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.leading).offset(35)
            make.centerY.equalToSuperview()
            make.size.equalTo(iconSize)
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
