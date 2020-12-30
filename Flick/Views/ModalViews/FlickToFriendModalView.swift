//
//  FlickToFriendModalView.swift
//  Flick
//
//  Created by Haiying W on 12/29/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class FlickToFriendModalView: UIView {

    // MARK: - Private View Vars
    private var cancelButton = UIButton()
    private let containerView = UIView()
    private let flickToFriendLabel = UILabel()
    private let friendsTableView = UITableView()
    private let mediaNameLabel = UILabel()
    private let mediaPosterImageView = UIImageView()
    private let messageTextField = UITextField()
    private let onlyFriendSeeLabel = UILabel()
    private var shareButton = UIButton()

    // MARK: - Private Data Vars
    private var friends: [UserProfile] = []
    private let friendsCellReuseIdentifier = "FriendsCellReuseIdentifier"
    weak var modalDelegate: ModalDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame = UIScreen.main.bounds

        backgroundColor = .backgroundOverlay

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        addSubview(containerView)

        flickToFriendLabel.text = "Flick to a friend"
        flickToFriendLabel.font = .boldSystemFont(ofSize: 20)
        containerView.addSubview(flickToFriendLabel)

        onlyFriendSeeLabel.text = "Only this friend will see"
        onlyFriendSeeLabel.textColor = .darkBlueGray2
        onlyFriendSeeLabel.font = .systemFont(ofSize: 12)
        containerView.addSubview(onlyFriendSeeLabel)

        mediaPosterImageView.backgroundColor = .lightGray
        mediaPosterImageView.layer.cornerRadius = 8
        mediaPosterImageView.layer.masksToBounds = true
        containerView.addSubview(mediaPosterImageView)

        mediaNameLabel.text = "Crash landing on you"
        mediaNameLabel.font = .boldSystemFont(ofSize: 14)
        containerView.addSubview(mediaNameLabel)

        messageTextField.placeholder = "Add a short message"
        messageTextField.backgroundColor = .lightGray2
        messageTextField.font = .systemFont(ofSize: 12)
        messageTextField.layer.cornerRadius = 16
        messageTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 39))
        messageTextField.leftViewMode = .always
        containerView.addSubview(messageTextField)

        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        friendsTableView.register(CollaboratorTableViewCell.self, forCellReuseIdentifier: friendsCellReuseIdentifier)
        friendsTableView.separatorStyle = .none
        friendsTableView.backgroundColor = .black
        containerView.addSubview(friendsTableView)

        cancelButton = RoundedButton(style: .gray, title: "Cancel")
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        containerView.addSubview(cancelButton)

        shareButton = RoundedButton(style: .purple, title: "Share")
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        containerView.addSubview(shareButton)

        setupConstraints()
        getFriends()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let buttonSize = CGSize(width: 72, height: 40)
        let containerViewSize = CGSize(width: 335, height: 630)
        let horizontalPadding = 24
        let verticalPadding = 30

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(containerViewSize)
        }

        flickToFriendLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.top.equalToSuperview().offset(36)
        }

        onlyFriendSeeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.top.equalTo(flickToFriendLabel.snp.bottom).offset(4)
        }

        mediaPosterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(53)
            make.top.equalTo(onlyFriendSeeLabel.snp.bottom).offset(verticalPadding)
            make.height.equalTo(90)
            make.width.equalTo(60)
        }

        mediaNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(mediaPosterImageView.snp.trailing).offset(12)
            make.top.equalTo(mediaPosterImageView.snp.top)
        }

        messageTextField.snp.makeConstraints { make in
            make.top.equalTo(mediaPosterImageView.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalToSuperview().inset(19.5)
            make.height.equalTo(39)
        }

        friendsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(messageTextField.snp.bottom).offset(15)
            make.bottom.equalTo(shareButton.snp.top).offset(-15)
        }

        shareButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(62.5)
            make.size.equalTo(buttonSize)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }

        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(62.5)
            make.size.equalTo(buttonSize)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }
    }

    private func getFriends() {
        NetworkManager.getFriends { [weak self] friends in
            guard let self = self else { return }
            self.friends = friends
            DispatchQueue.main.async {
                self.friendsTableView.reloadData()
            }
        }
    }

    @objc private func shareTapped() {

    }

    @objc private func cancelTapped() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.modalDelegate?.dismissModal(modalView: self)
        }
    }

}

extension FlickToFriendModalView: UITableViewDelegate, UITableViewDataSource {

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
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
}
