//
//  SelectIndicatorView.swift
//  Flick
//
//  Created by Haiying W on 7/1/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class SelectIndicatorView: UIView {

    private let checkImageView = UIImageView()

    init(width: CGFloat) {
        super.init(frame: .zero)

        backgroundColor = .clear
        layer.cornerRadius = width / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor

        checkImageView.image = UIImage(named: "check")
        checkImageView.isHidden = true
        addSubview(checkImageView)
        
        let checkImageSize = CGSize(width: 10, height: 8)
        checkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(checkImageSize)
        }
    }

    func select() {
        layer.borderColor = UIColor.gradientPurple.cgColor
        checkImageView.isHidden = false
    }

    func deselect() {
        layer.borderColor = UIColor.lightGray.cgColor
        checkImageView.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
