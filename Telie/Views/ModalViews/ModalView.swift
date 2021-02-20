//
//  ModalView.swift
//  Flick
//
//  Created by Haiying W on 1/17/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

protocol ModalDelegate: class {
    func dismissModal(modalView: UIView)
}

class ModalView: UIView {

    let containerView = UIView()

    weak var modalDelegate: ModalDelegate?

    init() {
        super.init(frame: .zero)
        frame = UIScreen.main.bounds
        backgroundColor = UIColor.darkBlueGray2.withAlphaComponent(0.7)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        addSubview(containerView)

        // Animate the pop up of modal view
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Dismiss modal with animation
    func dismissModal() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.modalDelegate?.dismissModal(modalView: self)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        // Dismiss modal view when tapping outside container view
        if touch?.view != containerView {
            dismissModal()
        }
    }

}
