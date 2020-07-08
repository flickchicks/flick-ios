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
    private let mediaImageView = UIImageView()
    private let saveMediaButton = UIButton()
    private let buttonSize = CGSize(width: 44, height: 44)

    private let cardHeight: CGFloat = 757
    private let cardHandleAreaHeight: CGFloat = 283

    private var cardVisible = false
    private var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }

    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .blue

        setupNavigationBar()

        mediaImageView.image = UIImage(named: "spiderman")
        mediaImageView.contentMode = .scaleAspectFill
        view.addSubview(mediaImageView)

        mediaImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(563)
        }

//        saveMediaButton.snp.makeConstraints { make in
//            make.centerY.equalTo(mediaCardViewController.top)
//            make.trailing.equalToSuperview().inset(40)
//            make.size.equalTo(buttonSize)
//        }

        setupCard()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)
//        let settingsButtonSize = CGSize(width: 22, height: 22)

//        navigationController?.navigationBar.isHidden = false
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.backgroundColor = .clear
//        navigationController?.navigationBar.shadowImage = UIImage()

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "whiteBackArrow"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

//        let settingsButton = UIButton()
//        settingsButton.setImage(UIImage(named: "settingsButton"), for: .normal)
//        settingsButton.snp.makeConstraints { make in
//            make.size.equalTo(settingsButtonSize)
//        }

//        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

//        let settingsBarButtonItem = UIBarButtonItem(customView: settingsButton)
//        navigationItem.rightBarButtonItem = settingsBarButtonItem
    }

    func setupCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        view.addSubview(visualEffectView)

        mediaCardViewController = MediaCardViewController()
        addChild(mediaCardViewController)
        view.addSubview(mediaCardViewController.view)

        saveMediaButton.setImage(UIImage(named: "newList"), for: .normal)
        saveMediaButton.layer.cornerRadius = buttonSize.width / 2
//        saveMediaButton.addTarget(self, action: #selector(showCreateListModal), for: .touchUpInside)
        view.addSubview(saveMediaButton)

        saveMediaButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(500)
            make.width.equalTo(44)
            make.height.equalTo(44)
            make.trailing.equalToSuperview().inset(40)
        }

        mediaCardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        mediaCardViewController.view.clipsToBounds = true

//        saveMediaButton.frame = CGRect(x: self.view.frame.height - 40, y: self.view.frame.height - cardHandleAreaHeight, width: 44, height: 44)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan))

        mediaCardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        mediaCardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)

        
    }

    @objc func handleCardTap(recognizer: UITapGestureRecognizer) {

    }

    @objc func handleCardPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.mediaCardViewController.handleArea)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransiton(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }

    func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.mediaCardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                    self.saveMediaButton.frame.origin.y = self.mediaCardViewController.view.frame.origin.y - 22
                case .collapsed:
                    self.mediaCardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                    self.saveMediaButton.frame.origin.y = self.mediaCardViewController.view.frame.origin.y - 22
                }
            }

            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }

            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)

        }
    }

    func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }

    func updateInteractiveTransiton(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }

    func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }

}
