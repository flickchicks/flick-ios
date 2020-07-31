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

    // MARK: - Private View Vars
    private var mediaCardViewController: MediaCardViewController!
    private let mediaImageView = UIImageView()
    private let saveMediaButton = UIButton()
    private var visualEffectView: UIVisualEffectView!

    // MARK: - Private Data Vars
    private var animationProgressWhenInterrupted: CGFloat = 0
    private let buttonSize = CGSize(width: 72, height: 72)
    private var cardExpanded = false
    private var expandedCardHeight: CGFloat!
    private var collapsedCardHeight: CGFloat!
    private var mediaImageHeight: CGFloat!
    private var nextState: CardState {
        return cardExpanded ? .collapsed : .expanded
    }
    private var runningAnimations = [UIViewPropertyAnimator]()

    override func viewDidLoad() {
        super.viewDidLoad()

        expandedCardHeight = 0.9 * view.frame.height
        collapsedCardHeight = 0.4 * view.frame.height
        mediaImageHeight = 0.6 * view.frame.height

        setupNavigationBar()

        mediaImageView.image = UIImage(named: "dunkirk")
        mediaImageView.contentMode = .scaleAspectFill
        view.addSubview(mediaImageView)

        mediaImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(mediaImageHeight)
        }

        setupMediaCard()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "whiteBackArrow"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    private func setupMediaCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)

        // TODO: Initialize MediaCardViewController with the media object
        mediaCardViewController = MediaCardViewController()
        addChild(mediaCardViewController)
        view.addSubview(mediaCardViewController.view)

        saveMediaButton.frame = CGRect(x: self.view.frame.width - 68 - buttonSize.width/2,
                                       y: self.view.frame.height - collapsedCardHeight - buttonSize.width/2,
                                       width: buttonSize.width, height: buttonSize.height)
        saveMediaButton.setImage(UIImage(named: "saveButton"), for: .normal)
        saveMediaButton.layer.cornerRadius = buttonSize.width / 2
        saveMediaButton.addTarget(self, action: #selector(saveMedia), for: .touchUpInside)
        view.addSubview(saveMediaButton)

        mediaCardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - collapsedCardHeight, width: self.view.bounds.width, height: expandedCardHeight)
        mediaCardViewController.view.clipsToBounds = true

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan))
        panGestureRecognizer.delegate = self
        mediaCardViewController.scrollView.addGestureRecognizer(panGestureRecognizer)

        let handleAreaPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleAreaCardPan))
        mediaCardViewController.handleArea.addGestureRecognizer(handleAreaPanGestureRecognizer)
        
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func saveMedia() {
        print("Save media.")
    }

    @objc func handleAreaCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.3)
        case .changed:
            let translation = recognizer.translation(in: self.mediaCardViewController.handleArea)
            var fractionComplete = translation.y / expandedCardHeight
            fractionComplete = cardExpanded ? fractionComplete : -fractionComplete
            updateInteractiveTransiton(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }


    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.3)
        case .changed:
            let translation = recognizer.translation(in: self.mediaCardViewController.scrollView)
            var fractionComplete = (translation.y * 2) / expandedCardHeight
            fractionComplete = cardExpanded ? fractionComplete : -fractionComplete
            updateInteractiveTransiton(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }

    private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.mediaCardViewController.view.frame.origin.y = self.view.frame.height - self.expandedCardHeight
                    self.saveMediaButton.frame.origin.y = self.mediaCardViewController.view.frame.origin.y - self.buttonSize.width/2
                case .collapsed:
                    self.mediaCardViewController.view.frame.origin.y = self.view.frame.height - self.collapsedCardHeight
                    self.saveMediaButton.frame.origin.y = self.mediaCardViewController.view.frame.origin.y - self.buttonSize.width/2
                }
            }

            frameAnimator.addCompletion { _ in
                self.cardExpanded = !self.cardExpanded
                self.runningAnimations.removeAll()
            }

            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)

        }
    }

    private func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }

    private func updateInteractiveTransiton(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }

    private func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

}

extension MediaViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
