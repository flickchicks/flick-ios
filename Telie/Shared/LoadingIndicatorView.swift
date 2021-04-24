//
//  LoadingIndicatorView.swift
//  Telie
//
//  Created by Lucy Xu on 4/24/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

class LoadingIndicatorView: UIView {

    let containerView = UIView()

    init() {
        super.init(frame: .zero)
        frame = UIScreen.main.bounds
        backgroundColor = .lightPurple
        layer.cornerRadius = 15

        let spinner = NVActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: 35, height: 35),
            type: .lineSpinFadeLoader,
            color: .gradientPurple
        )
        addSubview(spinner)

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        spinner.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
