//
//  GroupVoteViewController.swift
//  Flick
//
//  Created by Haiying W on 1/23/21.
//  Copyright © 2021 flick. All rights reserved.
//

import NVActivityIndicatorView
import UIKit
import NotificationBannerSwift

protocol GroupVoteDelegate: class {
    func hideNavigationBarItems()
    func showNavigationBarItems()
}

class GroupVoteViewController: UIViewController {

    // MARK: - Private View Vars
    private let addIdeasButton = UIButton()
    private let mediaInformationTableView = UITableView(frame: .zero, style: .plain)
    private let moreInfoView = UIStackView()
    private let noIdeasLabel = UILabel()
    private let numIdeasLabel = UILabel()
    private let posterImageView = UIImageView()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 30, height: 30),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let voteMaybeButton = UIButton()
    private let voteNoButton = UIButton()
    private let voteYesButton = UIButton()

    // MARK: - Data Vars
    private var currentMedia: Media?
    weak var delegate: GroupVoteDelegate?
    private var groupId: Int
    private var ideas: [Media] = [] {
        didSet {
            currentMedia = ideas.last
            if ideas.isEmpty {
                DispatchQueue.main.async {
                    self.setupNoIdeas()
                }
            } else {
                DispatchQueue.main.async {
                    self.setupIdeas()
                }
            }
        }
    }
    private var lastRequestTime: Date?
    private var longPressRecognizer: UILongPressGestureRecognizer!
    private var timer: Timer?

    init(groupId: Int) {
        self.groupId = groupId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressedPoster))

        numIdeasLabel.textColor = .darkBlueGray2
        numIdeasLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(numIdeasLabel)

        posterImageView.backgroundColor = .lightGray2
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.layer.cornerRadius = 25
        posterImageView.layer.masksToBounds = true
        posterImageView.isUserInteractionEnabled = true
        view.addSubview(posterImageView)

        addIdeasButton.setTitle("＋ Add Ideas", for: .normal)
        addIdeasButton.setTitleColor(.gradientPurple, for: .normal)
        addIdeasButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        addIdeasButton.backgroundColor = .lightPurple
        addIdeasButton.layer.borderWidth = 2
        addIdeasButton.layer.borderColor = UIColor.gradientPurple.cgColor
        addIdeasButton.layer.cornerRadius = 20
        addIdeasButton.addTarget(self, action: #selector(addIdeasPressed), for: .touchUpInside)
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
        moreInfoView.isHidden = true
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
        mediaInformationTableView.isScrollEnabled = false
        mediaInformationTableView.register(MediaSummaryTableViewCell.self, forCellReuseIdentifier: MediaSummaryTableViewCell.reuseIdentifier)
        view.addSubview(mediaInformationTableView)

        noIdeasLabel.text = "Add or auto-generate ideas by tapping below!"
        noIdeasLabel.textColor = .darkBlueGray2
        noIdeasLabel.textAlignment = .center
        noIdeasLabel.font = .systemFont(ofSize: 16)
        noIdeasLabel.numberOfLines = 0
        noIdeasLabel.isHidden = true
        view.addSubview(noIdeasLabel)

        voteNoButton.setImage(UIImage(named: "voteNoButton"), for: .normal)
        voteNoButton.addTarget(self, action: #selector(voteNoButtonPressed), for: .touchUpInside)
        view.addSubview(voteNoButton)

        voteMaybeButton.setImage(UIImage(named: "voteMaybeButton"), for: .normal)
        voteMaybeButton.addTarget(self, action: #selector(voteMaybeButtonPressed), for: .touchUpInside)
        view.addSubview(voteMaybeButton)

        voteYesButton.setImage(UIImage(named: "voteYesButton"), for: .normal)
        voteYesButton.addTarget(self, action: #selector(voteYesButtonPressed), for: .touchUpInside)
        view.addSubview(voteYesButton)

        view.addSubview(spinner)
        spinner.startAnimating()

        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getPendingIdeas()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Invalidate timer
        if timer != nil {
            timer?.invalidate()
            timer = nil
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

        spinner.snp.makeConstraints { make in
            make.center.equalTo(posterImageView)
        }

        mediaInformationTableView.snp.makeConstraints { make in
            make.edges.equalTo(posterImageView)
        }

        moreInfoView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top).offset(9)
            make.trailing.equalTo(posterImageView.snp.trailing).offset(-9)
            make.size.equalTo(CGSize(width: 220, height: 24))
        }

        noIdeasLabel.snp.makeConstraints { make in
            make.centerY.equalTo(posterImageView)
            make.leading.trailing.equalTo(posterImageView).inset(30)
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
            moreInfoView.isHidden = true
            // Send haptic feedback when long press begins
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        } else if sender.state == .ended {
            mediaInformationTableView.isHidden = true
            moreInfoView.isHidden = false
        }
    }

    @objc private func addIdeasPressed() {
        let window = UIApplication.shared.windows[0]
        let bottomPadding = window.safeAreaInsets.bottom

        delegate?.hideNavigationBarItems()

        let addToListVC = AddMediaViewController(
            type: .toGroup,
            height: Float(posterImageView.frame.height + 162 + bottomPadding),
            groupId: groupId
        )
        addToListVC.delegate = self
        addToListVC.modalPresentationStyle = .overCurrentContext
        present(addToListVC, animated: true, completion: nil)
    }

    @objc private func getPendingIdeas() {
        lastRequestTime = Date()
        NetworkManager.getPendingIdeas(id: groupId) { [weak self] (timestamp, ideas) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                // Update ideas only for the lastest request
                if timestamp.iso8601withFractionalSeconds ?? Date() >= self.lastRequestTime ?? Date() {
                    self.ideas = ideas
                }
                self.spinner.stopAnimating()
            }
        }
    }

    private func setupIdeas() {
        noIdeasLabel.isHidden = true
        moreInfoView.isHidden = false
        voteNoButton.isEnabled = true
        voteMaybeButton.isEnabled = true
        voteYesButton.isEnabled = true
        posterImageView.addGestureRecognizer(longPressRecognizer)

        // Invalidate timer
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }

        if let imageUrl = URL(string: self.currentMedia?.posterPic ?? "") {
            self.posterImageView.kf.setImage(with: imageUrl)
        } else {
            self.posterImageView.image = UIImage(named: "defaultMovie")
        }
        self.numIdeasLabel.text = "\(ideas.count) more idea\(ideas.count > 1 ? "s" : "") to vote"
        self.mediaInformationTableView.reloadData()
    }

    private func setupNoIdeas() {
        noIdeasLabel.isHidden = false
        moreInfoView.isHidden = true
        voteNoButton.isEnabled = false
        voteMaybeButton.isEnabled = false
        voteYesButton.isEnabled = false
        posterImageView.removeGestureRecognizer(longPressRecognizer)

        // Setup timer to get ideas every 5 seconds
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(getPendingIdeas), userInfo: nil, repeats: true)
        }

        self.numIdeasLabel.text = "No ideas to vote on"
        self.posterImageView.image = nil
        self.mediaInformationTableView.reloadData()
    }

    @objc private func voteNoButtonPressed() {
        vote(.no)
    }

    @objc private func voteMaybeButtonPressed() {
        vote(.maybe)
    }

    @objc private func voteYesButtonPressed() {
        vote(.yes)
    }

    private func vote(_ vote: Vote) {
        guard let media = currentMedia else { return }
        self.ideas.removeLast()
        NetworkManager.voteForIdea(groupId: groupId, mediaId: media.id, vote: vote) { _ in }
        // Send haptic feedback
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }

}

extension GroupVoteViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaSummaryTableViewCell.reuseIdentifier, for: indexPath) as? MediaSummaryTableViewCell,
              let media = currentMedia else {
            return UITableViewCell()
        }
        cell.configure(with: media)
        return cell
    }
}

extension GroupVoteViewController: AddMediaDelegate {

    func addMediaDismissed() {
        delegate?.showNavigationBarItems()
    }

    func reloadMedia() {
        getPendingIdeas()
        let banner = StatusBarNotificationBanner(
            title: "Ideas added",
            style: .info
        )
        banner.show()
    }

}
