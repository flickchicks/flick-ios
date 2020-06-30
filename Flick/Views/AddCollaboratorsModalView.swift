//
//  AddCollaboratorsModalView.swift
//  Flick
//
//  Created by Lucy Xu on 6/21/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SnapKit

class AddCollaboratorModalView: UIView {

    // MARK: - Private View Vars
    private var collaboratorsTableView: UITableView!
    private let collaboratorsTitleLabel = UILabel()
    private let containerView = UIView()
    private let copyLinkButton = UIButton()
    private let dismissButton = UIButton()
    private var inviteCollaboratorsTableView: UITableView!
    private let inviteSearchBar = UISearchBar()
    private let inviteTitleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let noFriendsLabel = UILabel()


    // MARK: - Private Data Vars
    weak var delegate: ModalDelegate?
    private let collaboratorCellReuseIdentifier = "CollaboratorCellReuseIdentifier"
    private var collaborators: [Collaborator] = [
        Collaborator(name: "Cindy Huang", isOwner: true, image: "", isAdded: true),
        Collaborator(name: "Lucy Xu", isOwner: false, image: "", isAdded: true)
    ]
    private var allFriends: [Collaborator] = [
        Collaborator(name: "Olivia Li", isOwner: false, image: "", isAdded: false),
        Collaborator(name: "Vivi Ye", isOwner: false, image: "", isAdded: false),
        Collaborator(name: "Aaastha Shah", isOwner: false, image: "", isAdded: false),
        Collaborator(name: "Haiying Weng", isOwner: false, image: "", isAdded: false)
    ]
    private var friends: [Collaborator] = [
        Collaborator(name: "Olivia Li", isOwner: false, image: "", isAdded: false),
        Collaborator(name: "Vivi Ye", isOwner: false, image: "", isAdded: false),
        Collaborator(name: "Aaastha Shah", isOwner: false, image: "", isAdded: false),
        Collaborator(name: "Haiying Weng", isOwner: false, image: "", isAdded: false)
    ]

    private let inviteCollaboratorCellReuseIdentifier = "InviteCollaboratorCellReuseIdentifier"

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.darkBlueGray2.withAlphaComponent(0.7)

        collaboratorsTitleLabel.text = "Collaborators"
        collaboratorsTitleLabel.textColor = .black
        collaboratorsTitleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(collaboratorsTitleLabel)

        dismissButton.setTitle("Done", for: .normal)
        dismissButton.setTitleColor(.gradientPurple, for: .normal)
        dismissButton.titleLabel?.font = .systemFont(ofSize: 14)
        dismissButton.layer.cornerRadius = 12
        dismissButton.layer.backgroundColor = UIColor.lightPurple.cgColor
        dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        containerView.addSubview(dismissButton)

        subtitleLabel.text = "Collaborators can add or remove media and collaborators. The owner can edit privacy settings."
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .darkBlueGray2
        subtitleLabel.font = .systemFont(ofSize: 12)
        containerView.addSubview(subtitleLabel)

        collaboratorsTableView = UITableView(frame: .zero, style: .plain)
        collaboratorsTableView.dataSource = self
        collaboratorsTableView.delegate = self
        collaboratorsTableView.isScrollEnabled = true
        collaboratorsTableView.alwaysBounceVertical = false
        collaboratorsTableView.register(CollaboratorTableViewCell.self, forCellReuseIdentifier: collaboratorCellReuseIdentifier)
        collaboratorsTableView.separatorStyle = .none
        containerView.addSubview(collaboratorsTableView)

        inviteTitleLabel.text = "Invite"
        inviteTitleLabel.textColor = .black
        inviteTitleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(inviteTitleLabel)

        copyLinkButton.setTitle("Copy link", for: .normal)
        copyLinkButton.setTitleColor(.mediumGray, for: .normal)
        copyLinkButton.titleLabel?.font = .systemFont(ofSize: 10)
        copyLinkButton.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        containerView.addSubview(copyLinkButton)

        inviteSearchBar.placeholder = "Search friends"
        inviteSearchBar.delegate = self
        inviteSearchBar.backgroundImage = UIImage()
        inviteSearchBar.searchTextField.backgroundColor = .clear
        inviteSearchBar.searchTextField.textColor = .mediumGray
        inviteSearchBar.searchTextField.font = .systemFont(ofSize: 12)
        inviteSearchBar.searchTextField.clearButtonMode = .never
        inviteSearchBar.layer.cornerRadius = 18
        inviteSearchBar.layer.borderWidth = 1
        inviteSearchBar.layer.borderColor = UIColor.mediumGray.cgColor
        inviteSearchBar.searchTextPositionAdjustment = UIOffset(horizontal: 12, vertical: 0)
        inviteSearchBar.showsCancelButton = false
        containerView.addSubview(inviteSearchBar)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        addSubview(containerView)

        setupConstraints()

        if friends.count > 0 {
            inviteCollaboratorsTableView = UITableView(frame: .zero, style: .plain)
            inviteCollaboratorsTableView.dataSource = self
            inviteCollaboratorsTableView.delegate = self
            inviteCollaboratorsTableView.isScrollEnabled = true
            inviteCollaboratorsTableView.alwaysBounceVertical = false
            inviteCollaboratorsTableView.register(CollaboratorTableViewCell.self, forCellReuseIdentifier: collaboratorCellReuseIdentifier)
            inviteCollaboratorsTableView.separatorStyle = .none
            containerView.addSubview(inviteCollaboratorsTableView)

            let inviteCollaboratorsTableViewHeight = min(4, friends.count) * 57

            inviteCollaboratorsTableView.snp.makeConstraints { make in
                make.leading.equalTo(collaboratorsTitleLabel)
                make.trailing.equalTo(dismissButton)
                make.height.equalTo(inviteCollaboratorsTableViewHeight)
                make.top.equalTo(inviteSearchBar.snp.bottom).offset(17)
            }

        } else {

            noFriendsLabel.text = "Stop telling your friends what to watch when they always forget... Tell them to join Flick!"
            noFriendsLabel.textColor = .mediumGray
            noFriendsLabel.font = .systemFont(ofSize: 12)
            noFriendsLabel.textAlignment = .center
            containerView.addSubview(noFriendsLabel)

            noFriendsLabel.snp.makeConstraints { make in
                make.leading.equalTo(collaboratorsTitleLabel)
                make.trailing.equalTo(dismissButton)
                make.top.equalTo(inviteSearchBar.snp.bottom).offset(17)
                make.height.equalTo(193)
            }
        }

    }

    private func setupConstraints() {
        let copyLinkButtonSize = CGSize(width: 48, height: 12)
        let dismissButtonSize = CGSize(width: 60, height: 25)
        let horizontalPadding = 24
        let collaboratorsTitleLabelSize = CGSize(width: 117, height: 22)
        let inviteTitleLabelSize = CGSize(width: 48, height: 22)
        let verticalPadding = 36

        let collaboratorsTableViewHeight = min(collaborators.count, 4) * 57
        let friendsTableViewHeight = min(friends.count, 4) * 57

        let inviteSectionHeight = friends.count > 0 ? friendsTableViewHeight : 193
        let containerHeight = inviteSectionHeight + collaboratorsTableViewHeight + 277

        let containerViewSize = CGSize(width: 325, height: containerHeight)

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(containerViewSize)
        }

        collaboratorsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(verticalPadding)
            make.leading.equalTo(containerView).offset(horizontalPadding)
            make.size.equalTo(collaboratorsTitleLabelSize)
        }

        dismissButton.snp.makeConstraints { make in
            make.size.equalTo(dismissButtonSize)
            make.top.equalTo(containerView).offset(33)
            make.trailing.equalTo(containerView).inset(horizontalPadding)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(collaboratorsTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(collaboratorsTitleLabel)
            make.trailing.equalTo(dismissButton)
        }

        collaboratorsTableView.snp.makeConstraints { make in
            make.leading.equalTo(collaboratorsTitleLabel)
            make.trailing.equalTo(dismissButton)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.height.equalTo(collaboratorsTableViewHeight)
        }

        inviteTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(collaboratorsTableView.snp.bottom).offset(20.5)
            make.leading.equalTo(collaboratorsTitleLabel)
            make.size.equalTo(inviteTitleLabelSize)
        }

        copyLinkButton.snp.makeConstraints { make in
            make.trailing.equalTo(dismissButton)
            make.centerY.equalTo(inviteTitleLabel)
            make.size.equalTo(copyLinkButtonSize)
        }

        inviteSearchBar.snp.makeConstraints { make in
            make.leading.trailing.equalTo(collaboratorsTableView)
            make.height.equalTo(36)
            make.top.equalTo(inviteTitleLabel.snp.bottom).offset(18)
        }

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func dismiss() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.delegate?.dismissModal(modalView: self)
        }
    }

    @objc func copyLink() {

    }

}

extension AddCollaboratorModalView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == collaboratorsTableView ? collaborators.count : friends.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: collaboratorCellReuseIdentifier, for: indexPath) as? CollaboratorTableViewCell else { return UITableViewCell() }
        let collaborator = tableView == collaboratorsTableView ? collaborators[indexPath.row] : friends[indexPath.row]
        cell.configure(for: collaborator)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: collaboratorCellReuseIdentifier, for: indexPath) as? CollaboratorTableViewCell else { return }
        cell.isSelected.toggle()
    }

}

extension AddCollaboratorModalView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if allFriends.count > 0 {
            if searchText == "" {
                friends = allFriends
            } else {
                friends = allFriends.filter { $0.name.contains(searchText) }
            }
            inviteCollaboratorsTableView.reloadData()
        }
        print(searchText)
    }
}
