//
//  SuggestToFriendViewController.swift
//  Telie
//
//  Created by Lucy Xu on 3/31/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import NotificationBannerSwift
import NVActivityIndicatorView
import UIKit

class SuggestToFriendViewController: UIViewController {

    // MARK: - Private View Vars
    private var cancelButton = UIButton()
    private let friendsTableView = UITableView()
    private let mediaIconImageView = UIImageView()
    private let mediaInfoLabel = UILabel()
    private let mediaNameLabel = UILabel()
    private let mediaPosterImageView = UIImageView()
    private let messageTextField = UITextField()
    private let onlyFriendSeeLabel = UILabel()
    private var shareButton = UIButton()
    private let saveButton = UIButton()
    private let saveSpinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let suggestToFriendLabel = UILabel()

    // MARK: - Private Data Vars
    private var friends: [UserProfile] = []
    private let friendsCellReuseIdentifier = "FriendsCellReuseIdentifier"
    private let media: Media
    private var selectedFriends: [UserProfile] = []
    private var selectedIndexPaths: [IndexPath] = []

    init(media: Media) {
        self.media = media
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
        suggestToFriendLabel.text = "Suggest to friend"
        suggestToFriendLabel.font = .boldSystemFont(ofSize: 20)
        view.addSubview(suggestToFriendLabel)

        onlyFriendSeeLabel.text = "Only selected friend will see"
        onlyFriendSeeLabel.textColor = .darkBlueGray2
        onlyFriendSeeLabel.font = .systemFont(ofSize: 12)
        view.addSubview(onlyFriendSeeLabel)

        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.gradientPurple, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 14)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        view.addSubview(saveButton)

        mediaIconImageView.image = UIImage(named: media.isTv ? "tv" : "film")
        view.addSubview(mediaIconImageView)

        if let duration = media.duration?.inHourMinute,
           let dateReleased = media.dateReleased {
            let releaseYear = String(dateReleased.prefix(4))
            mediaInfoLabel.text = "\(duration) • \(releaseYear)"
        }
        mediaInfoLabel.textColor = .mediumGray
        mediaInfoLabel.font = .systemFont(ofSize: 12)
        view.addSubview(mediaInfoLabel)

        mediaPosterImageView.backgroundColor = .lightGray
        mediaPosterImageView.layer.cornerRadius = 8
        mediaPosterImageView.layer.masksToBounds = true
        if let posterPic = media.posterPic,
           let imageUrl = URL(string: posterPic) {
            mediaPosterImageView.kf.setImage(with: imageUrl)
        } else {
            mediaPosterImageView.image = UIImage(named: "defaultMovie")
        }
        view.addSubview(mediaPosterImageView)

        mediaNameLabel.text = media.title
        mediaNameLabel.numberOfLines = 0
        mediaNameLabel.font = .boldSystemFont(ofSize: 14)
        view.addSubview(mediaNameLabel)

        messageTextField.placeholder = "Add a short message"
        messageTextField.backgroundColor = .lightGray2
        messageTextField.font = .systemFont(ofSize: 12)
        messageTextField.layer.cornerRadius = 16
        messageTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 39))
        messageTextField.leftViewMode = .always
        messageTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 39))
        messageTextField.rightViewMode = .always
        messageTextField.delegate = self
        view.addSubview(messageTextField)

        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        friendsTableView.register(CollaboratorTableViewCell.self, forCellReuseIdentifier: friendsCellReuseIdentifier)
        friendsTableView.separatorStyle = .none
        friendsTableView.bounces = false
        friendsTableView.allowsMultipleSelection = true
        friendsTableView.showsVerticalScrollIndicator = false
        view.addSubview(friendsTableView)

        view.addSubview(spinner)
        spinner.startAnimating()

        view.addSubview(saveSpinner)

        setupConstraints()
        getFriends()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let horizontalPadding = 24
        let verticalPadding = 30

        suggestToFriendLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.top.equalToSuperview().offset(36)
        }

        onlyFriendSeeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.top.equalTo(suggestToFriendLabel.snp.bottom).offset(4)
        }

        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(suggestToFriendLabel)
            make.trailing.equalToSuperview().inset(4)
            make.size.equalTo(CGSize(width: 66, height: 34))
        }

        saveSpinner.snp.makeConstraints { make in
            make.center.equalTo(saveButton)
        }

        mediaPosterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.top.equalTo(onlyFriendSeeLabel.snp.bottom).offset(verticalPadding)
            make.height.equalTo(90)
            make.width.equalTo(60)
        }

        mediaNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(mediaPosterImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(40)
            make.top.equalTo(mediaPosterImageView.snp.top).offset(9)
        }

        mediaIconImageView.snp.makeConstraints { make in
            make.leading.equalTo(mediaNameLabel)
            make.top.equalTo(mediaNameLabel.snp.bottom).offset(9)
            make.height.width.equalTo(12)
        }

        mediaInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(mediaIconImageView.snp.trailing).offset(6)
            make.centerY.equalTo(mediaIconImageView)
        }

        messageTextField.snp.makeConstraints { make in
            make.top.equalTo(mediaPosterImageView.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalToSuperview().inset(19.5)
            make.height.equalTo(39)
        }

        friendsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(messageTextField.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(friendsTableView)
        }

    }

    private func getFriends() {
        NetworkManager.getFriends { [weak self] friends in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.friends = friends
                self.spinner.stopAnimating()
                self.friendsTableView.reloadData()
            }
        }
    }

    func clearSelectedFriends() {
        messageTextField.text = ""
        for indexPath in selectedIndexPaths {
            friendsTableView.deselectRow(at: indexPath, animated: false)
        }
        selectedFriends = []
        selectedIndexPaths = []
    }

    @objc private func saveButtonPressed() {
        saveButton.isHidden = true
        saveSpinner.startAnimating()
        guard selectedFriends.count > 0 else {
            saveButton.isHidden = false
            saveSpinner.stopAnimating()
            return
        }
        let selectedFriendIds = selectedFriends.map { $0.id }
        NetworkManager.suggestMediaToFriends(friendIds: selectedFriendIds, mediaId: media.id, message: messageTextField.text ?? "") { [weak self] success in
            guard let self = self else { return }
            if success {
                self.dismiss(animated: true) {
                    let banner = StatusBarNotificationBanner(
                        title: "Suggested to friend\(selectedFriendIds.count > 1 ? "s" : "")",
                        style: .info
                    )
                    banner.show()
                }
                self.saveSpinner.stopAnimating()
            }
        }
    }

}

extension SuggestToFriendViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendsCellReuseIdentifier, for: indexPath) as? CollaboratorTableViewCell else { return UITableViewCell() }
        let friend = friends[indexPath.row]
        cell.configure(for: friend, isOwner: false)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        selectedFriends.append(friend)
        selectedIndexPaths.append(indexPath)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let friend = friends[indexPath.row]
        selectedFriends.removeAll { $0.id == friend.id }
        selectedIndexPaths.removeAll { $0.section == indexPath.section && $0.row == indexPath.row }
    }

}

extension SuggestToFriendViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
