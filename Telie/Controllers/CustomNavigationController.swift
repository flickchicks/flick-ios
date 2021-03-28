//
//  CustomNavigationController.swift
//  Flick
//
//  Created by Haiying W on 1/18/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit
import Hero

class CustomNavigationController: UINavigationController {

    // MARK: - Properties

    private var popRecognizer: InteractivePopRecognizer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopRecognizer()
    }

    // MARK: - Setup

    // For setting up pop recognizer for the navigation controller
    // Reference: https://stackoverflow.com/a/41248703/5078779
    private func setupPopRecognizer() {
        popRecognizer = InteractivePopRecognizer(controller: self)
    }

}
