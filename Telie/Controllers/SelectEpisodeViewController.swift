//
//  CreateReactionViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 3/4/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

protocol EpisodeForReactionDelegate: AnyObject {
    func selectEpisodeForReaction(seasonIndex: Int, episode: EpisodeDetail, episodeIndex: Int)
}

class SelectEpisodeViewController: UIViewController {

    // MARK: - Private View Vars
    private var seasonsCollectionView: UICollectionView!
    private var episodesTableView: UITableView!
    private let episodeLabel = UILabel()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    weak var delegate: EpisodeForReactionDelegate?
    private var episodeDetails = [EpisodeDetail]()
    private var seasonDetails = [SeasonDetail]()
    private var selectedSeasonIndex: Int!

    init(seasonDetails: [SeasonDetail]) {
        super.init(nibName: nil, bundle: nil)
        self.seasonDetails = seasonDetails
        if !seasonDetails.isEmpty {
            self.episodeDetails = seasonDetails[0].episodeDetails ?? []
            self.selectedSeasonIndex = 0
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        seasonsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)

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
        return seasonDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCollectionViewCell.reuseIdentifier, for: indexPath) as? SeasonCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(seasonNumber: seasonDetails[indexPath.item].seasonNum)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSeasonIndex = indexPath.item
        if let episodeDetails = seasonDetails[indexPath.item].episodeDetails {
            self.episodeDetails = episodeDetails
            episodesTableView.reloadData()
        }
    }
}

extension SelectEpisodeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 40)
    }
}

extension SelectEpisodeViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeDetails.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.reuseIdentifier, for: indexPath) as? EpisodeTableViewCell else { return UITableViewCell() }
        let episode = episodeDetails[indexPath.row]
        var episodeTitle = ""
        if let name = episode.name {
            episodeTitle = ". \(name)"
        }
        cell.configure(episodeName: "\(episode.episodeNum)\(episodeTitle)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEpisode = episodeDetails[indexPath.row]
        delegate?.selectEpisodeForReaction(seasonIndex: selectedSeasonIndex, episode: selectedEpisode, episodeIndex: indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}
