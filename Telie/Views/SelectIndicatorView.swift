//
//  SelectIndicatorView.swift
//  Flick
//
//  Created by Haiying W on 7/1/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum SelectIndicatorViewType {
    case circular, rectangular
}

class SelectIndicatorView: UIView {

    private let checkImageView = UIImageView()

    init(width: CGFloat, type: SelectIndicatorViewType) {
        super.init(frame: .zero)

        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        layer.cornerRadius = type == .circular ? width/2 : 3
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor

        checkImageView.image = UIImage(named: "check")
        checkImageView.isHidden = true
        addSubview(checkImageView)
        
        checkImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
    }

    func select() {
        backgroundColor = .white
        layer.borderColor = UIColor.gradientPurple.cgColor
        checkImageView.isHidden = false
    }

    func deselect() {
        backgroundColor = UIColor.white.withAlphaComponent(0.3)
        layer.borderColor = UIColor.lightGray.cgColor
        checkImageView.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
