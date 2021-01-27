//
//  GroupVoteViewController.swift
//  Flick
//
//  Created by Haiying W on 1/23/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class GroupVoteViewController: UIViewController {

    // MARK: - Private View Vars
    private let addIdeasButton = UIButton()
    private let mediaInformationTableView = UITableView(frame: .zero, style: .plain)
    private let moreInfoView = UIStackView()
    private let numIdeasLabel = UILabel()
    private let posterImageView = UIImageView()
    private let voteMaybeButton = UIButton()
    private let voteNoButton = UIButton()
    private let voteYesButton = UIButton()

    // MARK: - Private Data Vars
    private var ideas: [Media] = []
    private let mediaSummaryReuseIdentifier = "MediaSummaryReuseIdentifier"
    private var media: Media? // temp to remove

    override func viewDidLoad() {
        super.viewDidLoad()

        numIdeasLabel.text = "No ideas yet"
        numIdeasLabel.textColor = .darkBlueGray2
        numIdeasLabel.font = .systemFont(ofSize: 16)
        view.addSubview(numIdeasLabel)

        posterImageView.backgroundColor = .lightGray
        posterImageView.contentMode = .scaleAspectFill
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
        addIdeasButton.layer.borderWidth = 2
        addIdeasButton.layer.borderColor = UIColor.gradientPurple.cgColor
        addIdeasButton.layer.cornerRadius = 20
        view.addSubview(addIdeasButton)

        let infoTextLabel = UILabel()
        infoTextLabel.text = "Press and hold for more info "
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
        mediaInformationTableView.backgroundColor = UIColor.movieWhite.withAlphaComponent(0.95)
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

        voteNoButton.setImage(UIImage(named: "voteNoButton"), for: .normal)
        view.addSubview(voteNoButton)

        voteMaybeButton.setImage(UIImage(named: "voteMaybeButton"), for: .normal)
        view.addSubview(voteMaybeButton)

        voteYesButton.setImage(UIImage(named: "voteYesButton"), for: .normal)
        view.addSubview(voteYesButton)

        setupConstraints()
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

    private func setupConstraints() {
        let voteButtonSize: CGSize = CGSize(width: 50, height: 50)

        numIdeasLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(38)
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(numIdeasLabel.snp.bottom).offset(12)
            make.bottom.equalTo(voteMaybeButton.snp.top).offset(-16)
            make.leading.trailing.equalToSuperview().inset(38)
        }

        mediaInformationTableView.snp.makeConstraints { make in
            make.edges.equalTo(posterImageView)
        }

        moreInfoView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top).offset(9)
            make.trailing.equalTo(posterImageView.snp.trailing).offset(-9)
            make.size.equalTo(CGSize(width: 220, height: 24))
        }

        addIdeasButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
            make.size.equalTo(CGSize(width: 112, height: 40))
        }

        voteNoButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(54)
            make.size.equalTo(voteButtonSize)
            make.bottom.equalTo(addIdeasButton.snp.top).offset(-30)
        }

        voteMaybeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(voteButtonSize)
            make.bottom.equalTo(addIdeasButton.snp.top).offset(-30)
        }

        voteYesButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(54)
            make.size.equalTo(voteButtonSize)
            make.bottom.equalTo(addIdeasButton.snp.top).offset(-30)
        }
    }

    @objc private func longPressedPoster(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            mediaInformationTableView.isHidden = false
        } else if sender.state == .ended {
            mediaInformationTableView.isHidden = true
        }
    }

}

extension GroupVoteViewController: UITableViewDelegate, UITableViewDataSource {

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
