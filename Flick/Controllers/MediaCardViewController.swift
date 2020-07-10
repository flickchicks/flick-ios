//
//  MediaCardViewController.swift
//  Flick
//
//  Created by Lucy Xu on 7/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import UIKit

enum CardState { case expanded, collapsed }

class MediaCardViewController: UIViewController {

    // MARK: - Private View Vars
    let handleArea = UIView()
    let handleIndicatorView = UIView()

    // MARK: - Private Data Vars
    let handleIndicatorViewSize = CGSize(width: 64, height: 5)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .movieWhite
        view.layer.cornerRadius = 36
        // Apply corner radius only to top left and bottom right corners
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        setupHandleArea()
        
    }

    private func setupHandleArea() {
        view.addSubview(handleArea)

        handleIndicatorView.layer.backgroundColor = UIColor.lightGray4.cgColor
        handleIndicatorView.layer.cornerRadius = 2
        view.addSubview(handleIndicatorView)

        handleArea.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(75)
        }

        handleIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(handleIndicatorViewSize)
            make.top.equalToSuperview().offset(12)
        }
    }

}
