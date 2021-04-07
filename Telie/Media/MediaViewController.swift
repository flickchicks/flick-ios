//
//  MediaViewController.swift
//  Flick
//
//  Created by Lucy Xu on 7/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Kingfisher
import NotificationBannerSwift
import UIKit

protocol SaveMediaDelegate: class {
    func saveMedia(selectedList: SimpleMediaList)
    func presentCreateNewList()
}

enum CardState {case collapsed, expanded }

class MediaViewController: UIViewController {

    // MARK: - Private View Vars
    private var mediaCardViewController: MediaCardViewController!
    private let mediaImageView = UIImageView()
    private let saveMediaButton = UIButton()
    private let shareButton = UIButton()

    // MARK: - Private Data Vars
    private var animationProgressWhenInterrupted: CGFloat = 0
    private let buttonSize = CGSize(width: 54, height: 54)
    private var cardExpanded = false
    private var expandedCardHeight: CGFloat!
    private var collapsedCardHeight: CGFloat!
    private var media: Media?
    private var mediaId: Int!
    private var mediaImageHeight: CGFloat!
    private var nextState: CardState {
        return cardExpanded ? .collapsed : .expanded
    }
    private var runningAnimations = [UIViewPropertyAnimator]()

    init(mediaId: Int, mediaImageUrl: String?) {
        super.init(nibName: nil, bundle: nil)
        self.mediaId = mediaId
        if let mediaImageUrl = mediaImageUrl {
            let url = URL(string: mediaImageUrl)
            self.mediaImageView.kf.setImage(with: url)
        } else {
            self.mediaImageView.image = UIImage(named: "defaultMovie")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        expandedCardHeight = 0.9 * view.frame.height
        collapsedCardHeight = 0.4 * view.frame.height
        mediaImageHeight = 0.6 * view.frame.height

        mediaImageView.contentMode = .scaleAspectFill
        view.addSubview(mediaImageView)

        mediaImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(mediaImageHeight)
        }
        
        setupMediaCard()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMediaInformation()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 34, height: 34)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrowCircle"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    private func setupMediaCard() {
        mediaCardViewController = MediaCardViewController()
        addChild(mediaCardViewController)
        view.addSubview(mediaCardViewController.view)

        saveMediaButton.frame = CGRect(x: self.view.frame.width - 60 - buttonSize.width/2,
                                       y: self.view.frame.height - collapsedCardHeight - buttonSize.width/2,
                                       width: buttonSize.width, height: buttonSize.height)
        saveMediaButton.setImage(UIImage(named: "saveButton"), for: .normal)
        saveMediaButton.layer.cornerRadius = buttonSize.width / 2
        saveMediaButton.addTarget(self, action: #selector(saveMediaTapped), for: .touchUpInside)
        view.addSubview(saveMediaButton)

        shareButton.frame = CGRect(x: self.view.frame.width - 60 - 3*buttonSize.width/2,
                                       y: self.view.frame.height - collapsedCardHeight - buttonSize.width/2,
                                       width: buttonSize.width, height: buttonSize.height)
        shareButton.setImage(UIImage(named: "shareButton"), for: .normal)
        shareButton.layer.cornerRadius = buttonSize.width / 2
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        view.addSubview(shareButton)

        mediaCardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - collapsedCardHeight, width: self.view.bounds.width, height: expandedCardHeight)
        mediaCardViewController.view.clipsToBounds = true

        let tableViewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(tableViewCardPan))
        tableViewPanGestureRecognizer.delegate = self
        mediaCardViewController.mediaInformationTableView.addGestureRecognizer(tableViewPanGestureRecognizer)

        let handleAreaPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleAreaCardPan))
        mediaCardViewController.handleArea.addGestureRecognizer(handleAreaPanGestureRecognizer)
    }

    private func getMediaInformation() {
        NetworkManager.getMedia(mediaId: mediaId) { [weak self] media in
            guard let self = self else { return }
            self.media = media
            DispatchQueue.main.async {
                self.mediaCardViewController.setupMedia(media: media)
            }
        }
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func saveMediaTapped() {
        present(SaveMediaViewController(mediaId: mediaId, type: .saveMedia), animated: true)
    }

    @objc func shareButtonTapped() {
        let shareMediaView = ShareMediaModalView()
        shareMediaView.modalDelegate = self
        shareMediaView.shareMediaDelegate = self
        showModalPopup(view: shareMediaView)
    }

    @objc func handleAreaCardPan(recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: mediaCardViewController.handleArea)
        let panDirection = velocity.y > 0 ? "Down" : "Up"

        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.2, panDirection: panDirection)
        case .changed:
            let translation = recognizer.translation(in: self.mediaCardViewController.handleArea)
            var fractionComplete = translation.y / expandedCardHeight
            fractionComplete = panDirection == "Down" ? fractionComplete : -fractionComplete
            updateInteractiveTransiton(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
            self.mediaCardViewController.updateTableScroll(isScrollEnabled: !self.cardExpanded)
        default:
            break
        }
    }

    @objc func tableViewCardPan(recognizer: UIPanGestureRecognizer) {

        let velocity = recognizer.velocity(in: mediaCardViewController.handleArea)
        let panDirection = velocity.y > 0 ? "Down" : "Up"

        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.3, panDirection: panDirection)
        case .changed:
            let translation = recognizer.translation(in: self.mediaCardViewController.mediaInformationTableView)
            var fractionComplete = (translation.y * 2) / expandedCardHeight
            fractionComplete = panDirection == "Down" ? fractionComplete : -fractionComplete
            updateInteractiveTransiton(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
            self.mediaCardViewController.updateTableScroll(isScrollEnabled: !self.cardExpanded)
        default:
            break
        }

    }

    private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval, panDirection: String) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                if panDirection == "Up" {
                    self.mediaCardViewController.view.frame.origin.y = self.view.frame.height - self.expandedCardHeight
                    self.saveMediaButton.frame.origin.y = self.mediaCardViewController.view.frame.origin.y - self.buttonSize.width/2
                    self.shareButton.frame.origin.y = self.mediaCardViewController.view.frame.origin.y - self.buttonSize.width/2
                }
                else {
                    self.mediaCardViewController.view.frame.origin.y = self.view.frame.height - self.collapsedCardHeight
                    self.saveMediaButton.frame.origin.y = self.mediaCardViewController.view.frame.origin.y - self.buttonSize.width/2
                    self.shareButton.frame.origin.y = self.mediaCardViewController.view.frame.origin.y - self.buttonSize.width/2
                }
            }

            frameAnimator.addCompletion { _ in
//                self.cardExpanded = panDirection == "Down" ? false : true
                self.runningAnimations.removeAll()
            }

            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)

        }
    }

    private func startInteractiveTransition(state: CardState, duration: TimeInterval, panDirection: String) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration, panDirection: panDirection)
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

extension MediaViewController: ModalDelegate {

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

}

extension MediaViewController: SaveMediaDelegate {

    func saveMedia(selectedList: SimpleMediaList) {
        NetworkManager.addToMediaList(listId: selectedList.id, mediaIds: [mediaId]) { list in
            let banner = StatusBarNotificationBanner(
                title: "Saved to \(selectedList.name)",
                style: .info
            )
            banner.show()
        }
    }

    func presentCreateNewList() {
        let newListViewController = NewListViewController(type: .createList)
//        newListViewController.createListDelegate = self
        present(newListViewController, animated: true)
    }

}

extension MediaViewController: ShareMediaDelegate {

    func showSuggestToFriendView() {
        if let media = media {
            present(SuggestToFriendViewController(media: media), animated: true)
        }
    }
    
    func shareToInstagramFeed() {
        guard let instagramUrl = URL(string: "instagram-stories://share") else {
            return
        }

        if UIApplication.shared.canOpenURL(instagramUrl) {
            guard let image = mediaImageView.image else { return }
            guard let imageData = image.pngData() else { return }
            let pasteboardItems: [String: Any] = [
                "com.instagram.sharedSticker.stickerImage": imageData,
                "com.instagram.sharedSticker.backgroundTopColor": "#D1BED7",
                "com.instagram.sharedSticker.backgroundBottomColor": "#B8B6DE",
                // This contentURL doesn't seem to work
                "com.instagram.sharedSticker.contentURL": "https://www.google.com/"
            ]
            let pasteboardOptions = [
                UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(300)
            ]
            UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
            UIApplication.shared.open(instagramUrl, options: [:], completionHandler: nil)
        } else {
            // Instagram app is not installed or can't be opened, pop up an alert
            print("no instagram")
        }
    }

}
