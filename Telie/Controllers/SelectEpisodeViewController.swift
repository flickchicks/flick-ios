//
//  CreateReactionViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 3/4/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class SelectEpisodeViewController: UIViewController {
    

    let seasonReuseIdentifier = "SeasonCollectionViewCell"
    let seasonCellHeight: CGFloat = 50

    var seasonNumbers: [Int] = [0, 1, 2]


    // MARK: - Private View Vars
    private var seasonsCollectionView: UICollectionView!
    private let browseButton = UIButton()
    private let seasonButton = UIButton()
    private let season2Button = UIButton()
    private let dividerView1 = UIView()
    private let dividerView2 = UIView()
    private let episodeLabel = UILabel()
    private let episodeButton = UIButton()
    private let episode2Button = UIButton()
    private let episode2TextLabel = UILabel()
    private let titleLabel = UILabel()
    private let titleTextLabel = UILabel()

    // MARK: - Private Data Var
//    private var visibility = Visibility.friends

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Episode"
        view.backgroundColor = .offWhite

        titleLabel.text = "Season"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        view.addSubview(titleLabel)
        
        let seasonsLayout = UICollectionViewFlowLayout()
        seasonsLayout.minimumInteritemSpacing = 12
        seasonsLayout.scrollDirection = .horizontal

        seasonsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: seasonsLayout)
        seasonsCollectionView.register(SeasonCollectionViewCell.self, forCellWithReuseIdentifier: SeasonCollectionViewCell.reuseIdentifier)
        seasonsCollectionView.delegate = self
        seasonsCollectionView.dataSource = self
        seasonsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 16)
        seasonsCollectionView.backgroundColor = .clear
        seasonsCollectionView.showsHorizontalScrollIndicator = false
        seasonsCollectionView.isScrollEnabled = false
        seasonsCollectionView.allowsSelection = false
        view.addSubview(seasonsCollectionView)
       
      

        episodeLabel.text = "Episode"
        episodeLabel.textColor = .black
        episodeLabel.font = .systemFont(ofSize: 14, weight: .bold)
        view.addSubview(episodeLabel)
        
        episodeButton.setTitle("1. The Boy in the Iceberg", for: .normal)
        episodeButton.setTitleColor(.darkBlue, for: .normal)
        episodeButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        episodeButton.backgroundColor = .none
        episodeButton.layer.cornerRadius = 8
        episodeButton.contentHorizontalAlignment = .left
        episodeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        view.addSubview(episodeButton)
        
        episode2Button.setTitle("2. The Avatar Returns", for: .normal)
        episode2Button.setTitleColor(.darkBlue, for: .normal)
        episode2Button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        episode2Button.backgroundColor = .lightGray2
        episode2Button.layer.cornerRadius = 8
        episode2Button.contentHorizontalAlignment = .left
        episode2Button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        view.addSubview(episode2Button)

        browseButton.setTitle("Browse", for: .normal)
        browseButton.setTitleColor(.darkBlueGray2, for: .normal)
        browseButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        browseButton.backgroundColor = .lightGray2
        browseButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
        browseButton.layer.borderWidth = 1
        browseButton.layer.cornerRadius = 13
        view.addSubview(browseButton)

        dividerView1.backgroundColor = .none
        view.addSubview(dividerView1)

        dividerView2.backgroundColor = .none
        view.addSubview(dividerView2)

        setupConstraints()
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
        }
    
    @objc private func backButtonPressed() {
            navigationController?.popViewController(animated: true)
        }


    private func setupConstraints() {
        let leadingTrailingPadding: CGFloat = 20
        let verticalPadding: CGFloat = 11
        
        let padding = 12

        seasonsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(containerView).inset(padding)
            make.height.equalTo(120)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
        }


        
//        seasonButton.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(10)
//            make.leading.equalToSuperview().offset(leadingTrailingPadding)
//            make.height.equalTo(26)
//            make.width.equalTo(78)
//        }
//
//        season2Button.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(10)
//            make.leading.equalTo(seasonButton.snp.trailing).offset(10)
//            make.height.equalTo(26)
//            make.width.equalTo(78)
//        }

        dividerView1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(seasonsCollectionView.snp.bottom).offset(verticalPadding)
            make.height.equalTo(1)
        }

        episodeLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView1.snp.bottom).offset(verticalPadding)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
        }
        
        episodeButton.snp.makeConstraints { make in
            make.top.equalTo(episodeLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
            make.height.equalTo(37)
            make.width.equalTo(350)
        }


        episode2Button.snp.makeConstraints { make in
            make.top.equalTo(episodeButton.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
            make.height.equalTo(37)
            make.width.equalTo(350)
        }


        dividerView2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(episodeButton.snp.bottom).offset(verticalPadding)
            make.height.equalTo(1)
        }




    }

//    @objc func keyboardWillShow(sender: NSNotification) {
//        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            var bottomPadding: CGFloat = -10
//            if #available(iOS 13.0, *) {
//                let window = UIApplication.shared.windows.first
//                if let padding = window?.safeAreaInsets.bottom {
//                    bottomPadding += padding
//                }
//            }
//            sendButton.snp.updateConstraints { update in
//                update.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardSize.height - bottomPadding)
//            }
//
//        }
//    }

//    @objc func sendButtonTapped() {
//        print("send tapped")
//    }

//    @objc func visibilityButtonTapped() {
//        let friendsAction = UIAlertAction(title: "Just My Friends", style: .default) { [weak self] action in
//            guard let self = self else { return }
//            self.visibility = Visibility.friends
//            self.visibilityButton.setTitle("Visible to Friends  ", for: .normal)
//        }
//        let anyoneAction = UIAlertAction(title: "Anyone", style: .default) { [weak self] action in
//            guard let self = self else { return }
//            self.visibility = Visibility.public
//            self.visibilityButton.setTitle("Visible to Anyone  ", for: .normal)
//        }
//
//        let visibilityAlert = UIAlertController(title: "Visibility", message: nil, preferredStyle: .actionSheet)
//
//        visibilityAlert.addAction(friendsAction)
//        visibilityAlert.addAction(anyoneAction)
//
//        self.present(visibilityAlert, animated: true)
//    }

//    @objc func spoilerButtonTapped() {
//        let hasSpoilerAction = UIAlertAction(title: "Contains Spoilers", style: .default) { [weak self] action in
//            guard let self = self else { return }
//            self.isSpoiler = true
//            self.spoilerButton.setTitle("Contains Spoiler  ", for: .normal)
//        }
//        let noSpoilerAction = UIAlertAction(title: "No Spoilers", style: .default) { [weak self] action in
//            guard let self = self else { return }
//            self.isSpoiler = false
//            self.spoilerButton.setTitle("No Spoiler  ", for: .normal)
//        }
//
//        let spoilerAlert = UIAlertController(title: "Spoiler Content", message: nil, preferredStyle: .actionSheet)
//
//        spoilerAlert.addAction(hasSpoilerAction)
//        spoilerAlert.addAction(noSpoilerAction)
//
//        self.present(spoilerAlert, animated: true)
//    }

}


//extension SelectEpisodeViewController:  UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return seasonNumbers.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCollectionViewCell.reuseIdentifier, for: indexPath) as? SeasonCollectionViewCell else { return UICollectionViewCell() }
//        cell.configure(seasonNumber: seasonNumbers[indexPath.row])
//        return cell
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCollectionViewCell.reuseIdentifier, for: indexPath) as? SeasonCollectionViewCell else { return UICollectionViewCell() }
//        cell.configure(seasonNumber: seasonNumbers[indexPath.row])
//        return cell
//    }
//

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let seasonNumbers = seasonNumbers else { return }
//        let seasonNumber = seasonNumbers[indexPath.row]
//        navigationController?.pushViewController(MediaViewController(mediaId: media.id, mediaImageUrl: media.posterPic), animated: true)
//        print("selected \(seasonNumbers[indexPath.row])")
//    }

// }


extension SelectEpisodeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasonNumbers.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCollectionViewCell.reuseIdentifier, for: indexPath)
//                as? SeasonCollectionViewCell else { return UICollectionViewCell() }
//        cell.configure(seasonNumber: seasonNumbers[indexPath.item])
//        return cell
//    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCollectionViewCell.reuseIdentifier, for: indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: seasonReuseIdentifier, for: indexPath) as? SeasonCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(seasonNumber: seasonNumbers[indexPath.row])
        return cell
    }
}

extension SelectEpisodeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}

