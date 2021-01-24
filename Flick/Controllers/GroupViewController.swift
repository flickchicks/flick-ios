//
//  GroupViewController.swift
//  Flick
//
//  Created by Haiying W on 1/23/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    private let addIdeasButton = UIButton()
    private let moreInfoView = UIStackView()
    private let posterImageView = UIImageView()
    private let mediaInformationTableView = UITableView(frame: .zero, style: .plain)

    private var ideas: [Media] = []
    private let mediaSummaryReuseIdentifier = "MediaSummaryReuseIdentifier"
    private var media: Media? // temp to remove

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Group name" // TODO: Replace with actual name of group
        view.backgroundColor = .offWhite

        posterImageView.backgroundColor = .lightGray
        posterImageView.layer.cornerRadius = 25
        posterImageView.layer.masksToBounds = true
        posterImageView.isUserInteractionEnabled = true
        view.addSubview(posterImageView)

        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressedPoster))
        posterImageView.addGestureRecognizer(longPressRecognizer)

        addIdeasButton.setTitle("＋ Add Ideas", for: .normal)
        addIdeasButton.setTitleColor(.gradientPurple, for: .normal)
        addIdeasButton.titleLabel?.font = .systemFont(ofSize: 14)
        addIdeasButton.backgroundColor = .lightPurple
        addIdeasButton.layer.borderWidth = 1
        addIdeasButton.layer.borderColor = UIColor.gradientPurple.cgColor
        addIdeasButton.layer.cornerRadius = 20
        view.addSubview(addIdeasButton)

        let infoTextLabel = UILabel()
        infoTextLabel.text = "Tap and hold for more info "
        infoTextLabel.font = .systemFont(ofSize: 14)
        moreInfoView.addArrangedSubview(infoTextLabel)

        let infoIconImageView = UIImageView()
        infoIconImageView.image = UIImage(named: "infoIcon")
        infoIconImageView.contentMode = .scaleAspectFit
        infoIconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        moreInfoView.addArrangedSubview(infoIconImageView)

        moreInfoView.backgroundColor = .lightGray2
        moreInfoView.layer.opacity = 0.8
        moreInfoView.layer.cornerRadius = 12
        moreInfoView.isLayoutMarginsRelativeArrangement = true
        moreInfoView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        view.addSubview(moreInfoView)

        mediaInformationTableView.isHidden = true
        mediaInformationTableView.backgroundColor = UIColor.movieWhite.withAlphaComponent(0.9)
        mediaInformationTableView.allowsSelection = false
        mediaInformationTableView.isUserInteractionEnabled = true
        mediaInformationTableView.delegate = self
        mediaInformationTableView.dataSource = self
        mediaInformationTableView.bounces = false
        mediaInformationTableView.separatorStyle = .none
        mediaInformationTableView.setNeedsLayout()
        mediaInformationTableView.layoutIfNeeded()
        mediaInformationTableView.contentInset = UIEdgeInsets(top: 24, left: 10, bottom: 24, right: 10)
        mediaInformationTableView.layer.cornerRadius = 25
        mediaInformationTableView.register(MediaSummaryTableViewCell.self, forCellReuseIdentifier: mediaSummaryReuseIdentifier)
        view.addSubview(mediaInformationTableView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkManager.getMedia(mediaId: 1) { media in
            self.media = media
            if let url = URL(string: media.posterPic ?? "") {
                self.posterImageView.kf.setImage(with: url)
            }
            self.mediaInformationTableView.reloadData()
        }
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

    private func setupConstraints() {
        let posterWidth = UIScreen.main.bounds.width - 60
        let posterHeight = posterWidth * 3 / 2

        posterImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: posterWidth, height: posterHeight))
        }

        mediaInformationTableView.snp.makeConstraints { make in
            make.edges.equalTo(posterImageView)
        }

        moreInfoView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top).offset(9)
            make.trailing.equalTo(posterImageView.snp.trailing).offset(-9)
            make.size.equalTo(CGSize(width: 205, height: 24))
        }

        addIdeasButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.size.equalTo(CGSize(width: 112, height: 40))
        }
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func longPressedPoster(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            mediaInformationTableView.isHidden = false
        } else if sender.state == .ended {
            mediaInformationTableView.isHidden = true
        }
    }

}

extension GroupViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: mediaSummaryReuseIdentifier, for: indexPath) as? MediaSummaryTableViewCell,
              let media = media else {
            return UITableViewCell()
        }
        cell.configure(with: media)
        return cell
    }
}
