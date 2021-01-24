//
//  NotificationsTabPageViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class NotificationsTabPageViewController: UIPageViewController {

    // MARK: - Private View Vars
    private var noticationsViewController: ActivityViewController!
    private var pages: [UIViewController] = [UIViewController]()
    private var suggestionsViewController: SuggestionsViewController!
    weak var notificationsTabDelegate: NotificationsTabDelegate?

    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeDetected))
        leftSwipeGestureRecognizer.direction = .left
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeDetected))
        rightSwipeGestureRecognizer.direction = .right
        
        view.addGestureRecognizer(leftSwipeGestureRecognizer)
        view.addGestureRecognizer(rightSwipeGestureRecognizer)

        noticationsViewController = ActivityViewController()
        suggestionsViewController = SuggestionsViewController()
        pages = [noticationsViewController, suggestionsViewController]

        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }

    func setViewController(to index: Int) {
        let direction: UIPageViewController.NavigationDirection = (index == 1) ? .forward : .reverse
        self.setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
    }
    
    @objc func leftSwipeDetected() {
        setViewController(to: 1)
        notificationsTabDelegate?.setActiveIndex(to: 1)
    }
    
    @objc func rightSwipeDetected() {
        setViewController(to: 0)
        notificationsTabDelegate?.setActiveIndex(to: 0)
    }

}

