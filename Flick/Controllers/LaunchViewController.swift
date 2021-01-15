//
//  LaunchViewController.swift
//  Flick
//
//  Created by Lucy Xu on 1/14/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        view.backgroundColor = .offWhite
        
        logoImageView.image = UIImage(named: "flickLogo")
        view.addSubview(logoImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 117, height: 43))
        }
    }
    
}
