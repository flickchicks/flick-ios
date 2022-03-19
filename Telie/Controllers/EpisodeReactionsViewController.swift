//
//  EpisodeReactionsViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 3/18/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class EpisodeReactionsViewController: UIViewController {
  
    // MARK: - Private View Vars
    private var reactionPageCollectionView: UICollectionView!
    
    // MARK: - Private Data Vars
    private var currentPosition = 0
    private var reactionsViewControllers = [EpisodeReactionViewController]()
    private let reactionPageReuseIdentifier = "reactionPageCollectionView"
    
    private let reactions: [Int] = [0, 1, 2]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pageCollectionViewLayout = UICollectionViewFlowLayout()
        pageCollectionViewLayout.scrollDirection = .horizontal

        reactionPageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: pageCollectionViewLayout)
        reactionPageCollectionView.backgroundColor = .offWhite
        reactionPageCollectionView.register(EpisodeReactionVCCollectionViewCell.self, forCellWithReuseIdentifier: reactionPageReuseIdentifier)
        reactionPageCollectionView.dataSource = self
        reactionPageCollectionView.delegate = self
        reactionPageCollectionView.showsHorizontalScrollIndicator = false
        reactionPageCollectionView.isScrollEnabled = false
        view.addSubview(reactionPageCollectionView)
                
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeDetected))
        leftSwipeGestureRecognizer.direction = .left

        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeDetected))
        rightSwipeGestureRecognizer.direction = .right
        
        view.addGestureRecognizer(leftSwipeGestureRecognizer)
        view.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        setupConstraints()
        setupViewControllers()
       }
    
    private func setupConstraints() {
    
        reactionPageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func setupViewControllers() {
        reactions.forEach { reaction in
            let episodeReactionVC = EpisodeReactionViewController()
            reactionsViewControllers.append(episodeReactionVC)
        }
    }
    
    func setCurrentPosition(position: Int){
        print("setcurrentposition called on \(position)")
        currentPosition = position
        let path = IndexPath(item: currentPosition, section: 0)

        DispatchQueue.main.async {
            self.reactionPageCollectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc func leftSwipeDetected() {
        print("left swipe detected")
        let newPosition = currentPosition < reactions.count - 1 ? currentPosition + 1 : currentPosition
        setCurrentPosition(position: newPosition)
    }

    @objc func rightSwipeDetected() {
        print("right swipe detected")
        let newPosition = currentPosition > 0 ? currentPosition - 1 : currentPosition
        setCurrentPosition(position: newPosition)
    }

}

extension EpisodeReactionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reactionPageReuseIdentifier, for: indexPath) as? EpisodeReactionVCCollectionViewCell else { return UICollectionViewCell() }
        cell.configure()
//        cell.viewController.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setCurrentPosition(position: indexPath.item)
        

    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == reactionPageCollectionView {
            let currentIndex = Int(reactionPageCollectionView.contentOffset.x / reactionPageCollectionView.frame.size.width)
            setCurrentPosition(position: currentIndex)
        }
    }

//    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        if scrollView == searchResultPageCollectionView {
//            if let searchText = searchBar.text {
//                searchByText(searchText: searchText)
//            }
//        }
//    }
}

extension EpisodeReactionsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    
    }

}
