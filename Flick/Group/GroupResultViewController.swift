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
    private let votingStatusImageView = UIImageView(image: UIImage(named: "stillVotingIcon"))
    private let votingStatusLabel = UILabel()

    // MARK: - Private Data Vars
    private var groupId: Int

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

        votingStatusLabel.text = "2 friends are still voting"
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

        setupConstraints()
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
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VotingResultTableViewCell.reuseIdentifier, for: indexPath) as? VotingResultTableViewCell else { return UITableViewCell() }
        cell.configure(number: indexPath.row)
        return cell
    }

}
