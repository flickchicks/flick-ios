//
//  GroupTabPageViewController.swift
//  Flick
//
//  Created by Haiying W on 1/25/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

protocol GroupTabDelegate: class {
    func setActiveIndex(to index: Int)
}

class GroupTabPageViewController: UIPageViewController {

    private var pages: [UIViewController] = [UIViewController]()
    private var resultViewController: GroupResultViewController!
    var voteViewController: GroupVoteViewController!

    private var groupId:Int
    weak var tabDelegate: GroupTabDelegate?

    init(groupId: Int) {
        self.groupId = groupId
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

//    override init(
//        transitionStyle style: UIPageViewController.TransitionStyle,
//        navigationOrientation: UIPageViewController.NavigationOrientation,
//        options: [UIPageViewController.OptionsKey : Any]? = nil
//    ) {
//        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeDetected))
        leftSwipeGestureRecognizer.direction = .left

        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeDetected))
        rightSwipeGestureRecognizer.direction = .right

        view.addGestureRecognizer(leftSwipeGestureRecognizer)
        view.addGestureRecognizer(rightSwipeGestureRecognizer)

        resultViewController = GroupResultViewController(groupId: groupId)
        voteViewController = GroupVoteViewController(groupId: groupId)
        pages = [voteViewController, resultViewController]

        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }

    func setViewController(to index: Int) {
        let direction: UIPageViewController.NavigationDirection = (index == 1) ? .forward : .reverse
        self.setViewControllers([pages[index]], direction: direction, animated: true, completion: nil)
    }

    @objc func leftSwipeDetected() {
        setViewController(to: 1)
        tabDelegate?.setActiveIndex(to: 1)
    }

    @objc func rightSwipeDetected() {
        setViewController(to: 0)
        tabDelegate?.setActiveIndex(to: 0)
    }

}
