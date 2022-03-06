//
//  CreateReactionViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 3/4/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class SelectEpisodeViewController: UIViewController {

    var seasonNumbers: [Int] = [1, 2, 3, 4, 5, 6, 7]
    var episodeNames: [String] = ["1. The Boy in the Iceberg", "2. The Avatar Returns", "3. The Southern Air Temple", "4. The Warriors of Kyoshi", "5. The King of Omashu", "6. Imprisoned", "7. Winter Solstice: Part 1: The Spirit World", "8. Winter Solstice: Part 2: Avatar Roku", "9. The Waterbending Scroll"]

    // MARK: - Private View Vars
    private var seasonsCollectionView: UICollectionView!
    private var episodesTableView: UITableView!
    private let episodeLabel = UILabel()
    private let titleLabel = UILabel()

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
        seasonsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        seasonsCollectionView.backgroundColor = .clear
        seasonsCollectionView.showsHorizontalScrollIndicator = false
        seasonsCollectionView.isScrollEnabled = true
        seasonsCollectionView.allowsSelection = true
        view.addSubview(seasonsCollectionView)
        
        episodesTableView = UITableView(frame: .zero, style: .plain)
        episodesTableView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        episodesTableView.dataSource = self
        episodesTableView.delegate = self
        episodesTableView.backgroundColor = .clear
        episodesTableView.allowsMultipleSelection = false
        episodesTableView.isScrollEnabled = true
        episodesTableView.alwaysBounceVertical = true
        episodesTableView.bounces = true
        episodesTableView.showsVerticalScrollIndicator = false
        episodesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        episodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: EpisodeTableViewCell.reuseIdentifier)
        episodesTableView.separatorStyle = .none
        view.addSubview(episodesTableView)
       
        episodeLabel.text = "Episode"
        episodeLabel.textColor = .black
        episodeLabel.font = .systemFont(ofSize: 14, weight: .bold)
        view.addSubview(episodeLabel)
  
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
            print("back button pressed")
            navigationController?.popViewController(animated: true)
        }


    private func setupConstraints() {
        let leadingTrailingPadding: CGFloat = 20
        let verticalPadding: CGFloat = 11

        seasonsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
        }

        episodeLabel.snp.makeConstraints { make in
            make.top.equalTo(seasonsCollectionView.snp.bottom).offset(verticalPadding)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
        }
        
        episodesTableView.snp.makeConstraints { make in
            make.top.equalTo(episodeLabel.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

    }
}

extension SelectEpisodeViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasonNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCollectionViewCell.reuseIdentifier, for: indexPath) as? SeasonCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(seasonNumber: seasonNumbers[indexPath.row])
        return cell
    }
}

extension SelectEpisodeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 40)
    }
}

extension SelectEpisodeViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeNames.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.reuseIdentifier, for: indexPath) as? EpisodeTableViewCell else { return UITableViewCell() }
        cell.configure(episodeName: episodeNames[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeName = episodeNames[indexPath.row]
        print("clicked! \(episodeName)")
    }
}
