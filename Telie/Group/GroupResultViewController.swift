//
//  GroupResultViewController.swift
//  Flick
//
//  Created by Haiying W on 1/25/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class GroupResultViewController: UIViewController {

    // MARK: - Private View Vars
    private let resultsTableView = UITableView()
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let votingStatusImageView = UIImageView()
    private let votingStatusLabel = UILabel()

    // MARK: - Private Data Vars
    private var groupId: Int
    private var groupResult: GroupResult?

    init(groupId: Int) {
        self.groupId = groupId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite

        view.addSubview(votingStatusImageView)

        votingStatusLabel.textColor = .darkBlueGray2
        votingStatusLabel.font = .systemFont(ofSize: 14)
        view.addSubview(votingStatusLabel)

        resultsTableView.backgroundColor = .offWhite
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.separatorStyle = .none
        resultsTableView.showsVerticalScrollIndicator = false
        resultsTableView.register(VotingResultTableViewCell.self, forCellReuseIdentifier: VotingResultTableViewCell.reuseIdentifier)
        view.addSubview(resultsTableView)

        spinner.hidesWhenStopped = true
        if groupResult == nil {
            resultsTableView.backgroundView = spinner
            spinner.startAnimating()
        }

        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkManager.getGroupResults(id: groupId) { [weak self] groupResult in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.groupResult = groupResult
                let numNotVoted = groupResult.numMembers - groupResult.numVoted
                if groupResult.results.isEmpty {
                    self.votingStatusImageView.image = UIImage(named: "stillVotingIcon")
                    self.votingStatusImageView.snp.updateConstraints { update in
                        update.size.equalTo(CGSize(width: 32, height: 20))
                    }
                    self.votingStatusLabel.text = "No votes yet"
                } else if numNotVoted == 0 {
                    self.votingStatusImageView.image = UIImage(named: "votesInIcon")
                    self.votingStatusImageView.snp.updateConstraints { update in
                        update.size.equalTo(CGSize(width: 20, height: 20))
                    }
                    self.votingStatusLabel.text = "All votes are in!"
                } else if numNotVoted == 1 {
                    self.votingStatusImageView.image = UIImage(named: "stillVotingIcon")
                    self.votingStatusImageView.snp.updateConstraints { update in
                        update.size.equalTo(CGSize(width: 32, height: 20))
                    }
                    if !groupResult.userVoted {
                        self.votingStatusLabel.text = "You are still voting"
                    } else {
                        self.votingStatusLabel.text = "1 friend is still voting"
                    }
                } else {
                    self.votingStatusImageView.image = UIImage(named: "stillVotingIcon")
                    self.votingStatusImageView.snp.updateConstraints { update in
                        update.size.equalTo(CGSize(width: 32, height: 20))
                    }
                    if !groupResult.userVoted {
                        self.votingStatusLabel.text = "You and \(numNotVoted - 1) friends are still voting"
                    } else {
                        self.votingStatusLabel.text = "\(numNotVoted) friends are still voting"
                    }
                }
                self.spinner.stopAnimating()
                self.resultsTableView.reloadData()
            }
        }
    }

    private func setupConstraints() {
        votingStatusImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(19)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(CGSize(width: 32, height: 20))
        }

        votingStatusLabel.snp.makeConstraints { make in
            make.leading.equalTo(votingStatusImageView.snp.trailing).offset(8)
            make.centerY.equalTo(votingStatusImageView)
        }

        resultsTableView.snp.makeConstraints { make in
            make.top.equalTo(votingStatusImageView.snp.bottom).offset(7)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

}

extension GroupResultViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupResult?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VotingResultTableViewCell.reuseIdentifier, for: indexPath) as? VotingResultTableViewCell,
              let groupResult = groupResult else { return UITableViewCell() }
        let result = groupResult.results[indexPath.row]
        cell.configure(number: indexPath.row + 1, result: result)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupResult = groupResult else { return }
        let media = groupResult.results[indexPath.row]
        navigationController?.pushViewController(MediaViewController(mediaId: media.id, mediaImageUrl: media.posterPic), animated: true)
    }

}
