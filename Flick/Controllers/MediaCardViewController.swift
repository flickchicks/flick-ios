//
//  MediaCardViewController.swift
//  Flick
//
//  Created by Lucy Xu on 7/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import UIKit

class MediaCardViewController: UIViewController {

    let handleArea = UIView()
    let handleIndicatorView = UIView()
//    private let saveMediaButton = UIButton()

    let handleIndicatorViewSize = CGSize(width: 64, height: 5)
//    private let buttonSize = CGSize(width: 44, height: 44)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .movieWhite
        view.layer.cornerRadius = 36

        view.addSubview(handleArea)

        handleIndicatorView.layer.backgroundColor = UIColor.lightGray4.cgColor
        handleIndicatorView.layer.cornerRadius = 2
        view.addSubview(handleIndicatorView)

        handleArea.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }

        handleIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(handleIndicatorViewSize)
            make.top.equalToSuperview().offset(12)
        }

    }

}
