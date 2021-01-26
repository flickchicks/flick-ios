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

    // MARK: - Private Data Vars
    private let votingResultCellReuseIdentifier = "votingResultCellReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .offWhite

        resultsTableView.backgroundColor = .offWhite
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.separatorStyle = .none
        resultsTableView.showsVerticalScrollIndicator = false
        resultsTableView.register(VotingResultTableViewCell.self, forCellReuseIdentifier: votingResultCellReuseIdentifier)
        view.addSubview(resultsTableView)

        setupConstraints()
    }

    private func setupConstraints() {
        resultsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension GroupResultViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: votingResultCellReuseIdentifier, for: indexPath) as? VotingResultTableViewCell else { return UITableViewCell() }
        cell.configure(number: indexPath.row)
        return cell
    }

}
