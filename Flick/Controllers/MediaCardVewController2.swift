//
//  MediaCardVewController2.swift
//  Flick
//
//  Created by Lucy Xu on 8/16/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaCardViewController2: UIViewController {

    let handleArea = UIView()
    private let handleIndicatorView = UIView()
    private let handleIndicatorViewSize = CGSize(width: 64, height: 5)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .movieWhite
        view.layer.cornerRadius = 36
        // Apply corner radius only to top left and bottom right corners
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        view.addSubview(handleArea)
        handleIndicatorView.layer.backgroundColor = UIColor.lightGray4.cgColor
        handleIndicatorView.layer.cornerRadius = 2
        view.addSubview(handleIndicatorView)

        handleArea.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }

        handleIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(handleIndicatorViewSize)
            make.top.equalToSuperview().offset(12)
        }

    }

}
