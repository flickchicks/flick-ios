//
//  AddCollaboratorViewController.swift
//  Telie
//
//  Created by Lucy Xu on 3/31/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AddCollaboratorViewController: UIViewController {

    // MARK: - Private View Vars
    private var collaboratorsTableView: UITableView!
    private let collaboratorsTitleLabel = UILabel()
    private let copyLinkButton = UIButton()
    private var inviteCollaboratorsTableView: UITableView!
    private let inviteSearchBar = SearchBar()
    private let inviteTitleLabel = UILabel()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .circleStrokeSpin,
        color: .gradientPurple
    )
    private let subtitleLabel = UILabel()
    private let noFriendsLabel = UILabel()

    // MARK: - Private Data Vars
    private var allFriends: [UserProfile] = []
    private let collaboratorCellHeight = 57
    private var collaborators: [UserProfile]
    private var friends: [UserProfile] = []
    private var owner: UserProfile

    weak var listSettingsDelegate: ListSettingsDelegate?

    init(owner: UserProfile, collaborators: [UserProfile]) {
        self.owner = owner
        self.collaborators = [owner] + collaborators
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        collaboratorsTitleLabel.text = "Collaborators"
        collaboratorsTitleLabel.textColor = .black
        collaboratorsTitleLabel.font = .boldSystemFont(ofSize: 18)
        view.addSubview(collaboratorsTitleLabel)

        subtitleLabel.text = "Collaborators can add or remove media and collaborators. The owner can edit privacy settings."
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .darkBlueGray2
        subtitleLabel.font = .systemFont(ofSize: 12)
        view.addSubview(subtitleLabel)

        collaboratorsTableView = UITableView(frame: .zero, style: .plain)
        collaboratorsTableView.dataSource = self
        collaboratorsTableView.delegate = self
        collaboratorsTableView.allowsMultipleSelection = true
        collaboratorsTableView.isScrollEnabled = true
        collaboratorsTableView.alwaysBounceVertical = false
        collaboratorsTableView.showsVerticalScrollIndicator = false
        collaboratorsTableView.register(EditUserTableViewCell.self, forCellReuseIdentifier: EditUserTableViewCell.reuseIdentifier)
        collaboratorsTableView.separatorStyle = .none
        view.addSubview(collaboratorsTableView)

        inviteTitleLabel.text = "Invite"
        inviteTitleLabel.textColor = .black
        inviteTitleLabel.font = .boldSystemFont(ofSize: 18)
        view.addSubview(inviteTitleLabel)

        copyLinkButton.setTitle("Copy link", for: .normal)
        copyLinkButton.setTitleColor(.mediumGray, for: .normal)
        copyLinkButton.titleLabel?.font = .systemFont(ofSize: 10)
        copyLinkButton.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
//        containerView.addSubview(copyLinkButton)

        inviteSearchBar.placeholder = "Search friends"
        inviteSearchBar.delegate = self
        view.addSubview(inviteSearchBar)

        inviteCollaboratorsTableView = UITableView(frame: .zero, style: .plain)
        inviteCollaboratorsTableView.dataSource = self
        inviteCollaboratorsTableView.delegate = self
        inviteCollaboratorsTableView.allowsMultipleSelection = true
        inviteCollaboratorsTableView.isScrollEnabled = true
        inviteCollaboratorsTableView.alwaysBounceVertical = false
        inviteCollaboratorsTableView.showsVerticalScrollIndicator = false
        inviteCollaboratorsTableView.register(EditUserTableViewCell.self, forCellReuseIdentifier: EditUserTableViewCell.reuseIdentifier)
        inviteCollaboratorsTableView.separatorStyle = .none
        inviteCollaboratorsTableView.keyboardDismissMode = .onDrag

        if friends.isEmpty {
            view.addSubview(spinner)
            spinner.startAnimating()
        }

        noFriendsLabel.text = "Stop telling your friends what to watch when they always forget... \nTell them to join Telie!"
        noFriendsLabel.textColor = .darkBlue
        noFriendsLabel.numberOfLines = 0
        noFriendsLabel.font = .systemFont(ofSize: 12)
        noFriendsLabel.textAlignment = .center

        setupConstraints()

        NetworkManager.getFriends { [weak self] friends in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.allFriends = friends
                self.friends = friends
                self.setupFriendsView()
                self.spinner.stopAnimating()
            }
        }
    }

    private func setupConstraints() {
        let collaboratorsTitleLabelSize = CGSize(width: 117, height: 22)
        let horizontalPadding = 24
        let inviteTitleLabelSize = CGSize(width: 48, height: 22)
        let noFriendsSectionViewHeight = 3 * collaboratorCellHeight
        let roundButtonSize = CGSize(width: 84, height: 40)
        let verticalPadding = 36

        let collaboratorsTableViewHeight = min(collaborators.count, 3) * collaboratorCellHeight
        let containerHeight = noFriendsSectionViewHeight + collaboratorsTableViewHeight + Int(roundButtonSize.height) + 287

        collaboratorsTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalPadding)
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.size.equalTo(collaboratorsTitleLabelSize)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(collaboratorsTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(collaboratorsTitleLabel)
            make.trailing.equalToSuperview().inset(horizontalPadding)
        }

        collaboratorsTableView.snp.makeConstraints { make in
            make.leading.equalTo(collaboratorsTitleLabel)
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.height.equalTo(collaboratorsTableViewHeight)
        }

        inviteTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(collaboratorsTableView.snp.bottom).offset(20.5)
            make.leading.equalTo(collaboratorsTitleLabel)
            make.size.equalTo(inviteTitleLabelSize)
        }

//        copyLinkButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(horizontalPadding)
//            make.centerY.equalTo(inviteTitleLabel)
//            make.size.equalTo(copyLinkButtonSize)
//        }

        inviteSearchBar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(collaboratorsTableView)
            make.height.equalTo(40)
            make.top.equalTo(inviteTitleLabel.snp.bottom).offset(18)
        }

        spinner.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inviteSearchBar.snp.bottom).offset(20)
        }
    }

    private func setupFriendsView() {
        let inviteHeight = 3 * collaboratorCellHeight
        if friends.count > 0 {
            view.addSubview(inviteCollaboratorsTableView)

            inviteCollaboratorsTableView.snp.makeConstraints { make in
                make.leading.equalTo(collaboratorsTitleLabel)
                make.trailing.equalTo(subtitleLabel)
                make.height.equalTo(inviteHeight)
                make.top.equalTo(inviteSearchBar.snp.bottom).offset(17)
            }
        } else {
            view.addSubview(noFriendsLabel)

            noFriendsLabel.snp.makeConstraints { make in
                make.leading.equalTo(collaboratorsTitleLabel)
                make.trailing.equalTo(subtitleLabel)
                make.top.equalTo(inviteSearchBar.snp.bottom).offset(17)
                make.height.equalTo(inviteHeight)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func copyLink() {

    }

    func updateCollaborators(updatedList: MediaList) {
        collaborators = [updatedList.owner] + updatedList.collaborators
        collaboratorsTableView.reloadData()
        inviteCollaboratorsTableView.reloadData()
    }
}

extension AddCollaboratorViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == collaboratorsTableView ? collaborators.count : friends.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EditUserTableViewCell.reuseIdentifier, for: indexPath) as? EditUserTableViewCell else { return UITableViewCell() }
        if tableView == collaboratorsTableView {
            let collaborator = collaborators[indexPath.row]
            cell.configureForRemove(user: collaborator, isOwner: owner.id == collaborator.id)
            cell.delegate = self
        } else {
            let friend = friends[indexPath.row]
            let isAdded = collaborators.contains { $0.id == friend.id }
            cell.configureForAdd(user: friend, isAdded: isAdded)
            cell.delegate = self
        }
        return cell
    }
}

extension AddCollaboratorViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if allFriends.count > 0 {
            if searchText == "" {
                friends = allFriends
            } else {
                friends = allFriends.filter {
                    "\($0.name)".contains(searchText) || $0.username.contains(searchText)
                }
            }
            inviteCollaboratorsTableView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension AddCollaboratorViewController: EditUserCellDelegate {

    func addUserTapped(user: UserProfile) {
        listSettingsDelegate?.addCollaborator(collaborator: user)
    }

    func removeUserTapped(user: UserProfile) {
        listSettingsDelegate?.removeCollaborator(collaborator: user)
    }

}
