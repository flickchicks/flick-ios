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

    private var media: Media?
    private var mediaId: Int
    private var mediaName: String

//    init(media: Media) {
//        self.media = media
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

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
        episodesTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.leading.trailing.equalToSuperview()
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

    private func getMediaInformation() {
        NetworkManager.getMedia(mediaId: mediaId) { [weak self] media in
            guard let self = self else { return }
            self.media = media
            print(media)
        }
    }

}

extension MediaAllReactionsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeReactionsTableViewCell.reuseIdentifier, for: indexPath) as? EpisodeReactionsTableViewCell else { return UITableViewCell() }
//        cell.configure(media: results[indexPath.item])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }

}
