//
//  MediaViewController.swift
//  Flick
//
//  Created by Lucy Xu on 7/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import UIKit

class MediaViewController: UIViewController {

    enum CardState { case expanded, collapsed}

    private var mediaCardViewController: MediaCardViewController!
    private var visualEffectView: UIVisualEffectView!

    private let cardHeight: CGFloat = 600
    private let cardHandleAreaHeight: CGFloat = 65

    private var cardVisible = false
    private var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }

    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCard()
    }

    func setupCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)

        mediaCardViewController = MediaCardViewController()

    }

}
