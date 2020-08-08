//
//  UIViewController.swift
//  Flick
//
//  Created by Haiying W on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

extension UIViewController {

    func createInfoAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        alert.dismiss(animated: true, completion: nil)
    }

    func showModalPopup(view: UIView) {
        if let window = UIApplication.shared.windows.first(where: { window -> Bool in window.isKeyWindow}) {
            window.addSubview(view)
        }
    }

}
