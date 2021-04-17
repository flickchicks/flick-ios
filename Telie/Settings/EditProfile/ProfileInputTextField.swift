//
//  ProfileInputTextField.swift
//  Telie
//
//  Created by Lucy Xu on 4/17/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

class ProfileInputTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .systemFont(ofSize: 14)
        textColor = .black
        borderStyle = .none
        layer.backgroundColor = UIColor.offWhite.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.mediumGray.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: frame.height))
        leftViewMode = .always
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
