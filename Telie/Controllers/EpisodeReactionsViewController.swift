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
    private let replyButton = UIButton()

    // MARK: - Private Data Vars
    private var currentPosition = 0
    private var mediaId: Int
    private var mediaPosterPic: String?
    private let reactionPageReuseIdentifier = "reactionPageCollectionView"
    private var reactions = [Reaction]()
    private var reactionsViewControllers = [EpisodeReactionViewController]()

    init(mediaId: Int, mediaPosterPic: String?, reactions: [Reaction]) {
        self.mediaId = mediaId
        self.mediaPosterPic = mediaPosterPic
        self.reactions = reactions
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Squid Game"
        view.backgroundColor = .offWhite
       
        replyButton.setImage(UIImage(named: "reply"), for: .normal)
        replyButton.tintColor = .black
        replyButton.addTarget(self, action: #selector(replyButtonPressed), for: .touchUpInside)
        view.addSubview(replyButton)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           setupNavigationBar()
       }
    
    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)
        let iconButtonSize = CGSize(width: 30, height: 30)

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.07
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationController?.navigationBar.layer.shadowRadius = 8
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    
        let infoButton = UIButton()
        infoButton.setImage(UIImage(named: "settingsInfoIcon"), for: .normal)
        infoButton.tintColor = .black
        infoButton.snp.makeConstraints { make in
            make.size.equalTo(iconButtonSize)
        }
        infoButton.addTarget(self, action: #selector(iconButtonPressed), for: .touchUpInside)
        let infoButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoButtonItem
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func iconButtonPressed() {
        let mediaVC = MediaViewController(mediaId: mediaId, mediaImageUrl: mediaPosterPic)
        navigationController?.pushViewController(mediaVC, animated: true)
    }
    
    @objc private func replyButtonPressed() {
        navigationController?.pushViewController(ReplyReactionViewController(), animated: true)
    }
    
    private func setupConstraints() {
        reactionPageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
        }
        replyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
    }
    
    func setupViewControllers() {
        reactions.forEach { reaction in
            let episodeReactionVC = EpisodeReactionViewController(reaction: reaction)
            reactionsViewControllers.append(episodeReactionVC)
        }
    }
    
    func setCurrentPosition(position: Int){
        currentPosition = position
        let path = IndexPath(item: currentPosition, section: 0)

        DispatchQueue.main.async {
            self.reactionPageCollectionView.scrollToItem(at: path, at: .left, animated: true)
        }
    }
    
    @objc func leftSwipeDetected() {
        let newPosition = currentPosition < reactions.count - 1 ? currentPosition + 1 : currentPosition
        setCurrentPosition(position: newPosition)
    }

    @objc func rightSwipeDetected() {
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
        cell.configure(vc: reactionsViewControllers[indexPath.item])
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
}

extension EpisodeReactionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = self.view.frame.width - 40
            return CGSize(width: width, height: collectionView.frame.height)
        }
}
