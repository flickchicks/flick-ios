//
//  InteractivePopRecognizer.swift
//  Flick
//
//  Created by Haiying W on 1/17/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

// Reference: https://stackoverflow.com/a/41248703/5078779

class InteractivePopRecognizer: NSObject, UIGestureRecognizerDelegate {

    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        navigationController.viewControllers.count > 1
    }

    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
