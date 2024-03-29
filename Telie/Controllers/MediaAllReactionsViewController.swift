//
//  MediaAllReactionsViewController.swift
//  Telie
//
//  Created by Haiying W on 3/14/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class MediaAllReactionsViewController: UIViewController {

    private let episodesTableView = UITableView()
    private var reactButton = UIButton()
    private var seasonsCollectionView: UICollectionView!

    private var reactionsForMedia: ReactionsForMedia?
    private var selectedSeasonIndex: Int = 0
    private var media: Media?
    private var mediaId: Int
    private var mediaName: String

    init(mediaId: Int, mediaName: String) {
        self.mediaId = mediaId
        self.mediaName = mediaName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = mediaName
        view.backgroundColor = .offWhite

        episodesTableView.backgroundColor = .offWhite
        episodesTableView.dataSource = self
        episodesTableView.delegate = self
        episodesTableView.showsVerticalScrollIndicator = false
        episodesTableView.separatorStyle = .none
        episodesTableView.register(EpisodeReactionsTableViewCell.self, forCellReuseIdentifier: EpisodeReactionsTableViewCell.reuseIdentifier)
        view.addSubview(episodesTableView)

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
        view.addSubview(seasonsCollectionView)

        reactButton.setImage(UIImage(named: "reactButton"), for: .normal)
        reactButton.addTarget(self, action: #selector(reactButtonPressed), for: .touchUpInside)
        view.addSubview(reactButton)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMediaInformation()
    }

    private func setupConstraints() {
        seasonsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        episodesTableView.snp.makeConstraints { make in
            make.top.equalTo(seasonsCollectionView.snp.bottom).offset(10)
            make.bottom.leading.trailing.equalToSuperview()
        }

        reactButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(CGSize(width: 105, height: 48))
        }
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

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func iconButtonPressed() {
        let mediaVC = MediaViewController(mediaId: mediaId, mediaImageUrl: media?.posterPic)
        navigationController?.pushViewController(mediaVC, animated: true)
    }

    @objc func reactButtonPressed() {
        navigationController?.pushViewController(CreateReactionViewController(media: media), animated: true)
    }

    private func getMediaInformation() {
        NetworkManager.getMedia(mediaId: mediaId) { [weak self] media in
            guard let self = self else { return }
            self.media = media
            print(media)
        }

        NetworkManager.getAllReactions(mediaId: mediaId) { [weak self] reactionsForMedia in
            guard let self = self else { return }
            self.reactionsForMedia = reactionsForMedia
            print(reactionsForMedia)
            DispatchQueue.main.async {
                self.episodesTableView.reloadData()
                self.seasonsCollectionView.reloadData()
                if !reactionsForMedia.seasonDetails.isEmpty {
                    guard let episodeDetails = reactionsForMedia.seasonDetails[0].episodeDetails, !episodeDetails.isEmpty else { return }
                    self.seasonsCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
                }
            }
        }
    }
}

extension MediaAllReactionsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let seasonDetails = reactionsForMedia?.seasonDetails, !seasonDetails.isEmpty {
            return reactionsForMedia?.seasonDetails[selectedSeasonIndex].episodeDetails?.count ?? 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeReactionsTableViewCell.reuseIdentifier, for: indexPath) as? EpisodeReactionsTableViewCell,
              let reactionsForMedia = self.reactionsForMedia else { return UITableViewCell() }
        if let episode = reactionsForMedia.seasonDetails[selectedSeasonIndex].episodeDetails?[indexPath.row] {
            cell.configure(episode: episode)
        }
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }

}

extension MediaAllReactionsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reactionsForMedia?.seasonDetails.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCollectionViewCell.reuseIdentifier, for: indexPath) as? SeasonCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(seasonNumber: reactionsForMedia?.seasonDetails[indexPath.item].seasonNum ?? 0)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSeasonIndex = indexPath.item
        episodesTableView.reloadData()
    }
}

extension MediaAllReactionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 40)
    }
}

extension MediaAllReactionsViewController: PushReactionsDelegate {
    func pushReactionsVC(episode: EpisodeDetail, selectedReactionId: Int) {
        NetworkManager.getEpisodeReactions(episodeId: episode.id) { [weak self] reactions in
            guard let self = self else { return }
            print(reactions)
            let vc = EpisodeReactionsViewController(mediaId: self.mediaId, mediaName: self.mediaName, mediaPosterPic: self.media?.posterPic, reactions: reactions, selectedReactionId: selectedReactionId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
