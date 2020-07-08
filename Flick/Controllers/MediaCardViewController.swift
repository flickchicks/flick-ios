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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

        view.addSubview(handleArea)

        handleArea.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }

    }

}
