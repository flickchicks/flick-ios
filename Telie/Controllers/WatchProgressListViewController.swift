//
//  WatchProgressListViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 4/16/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class WatchProgressListViewController: UIViewController {
    
    var progressList = [
        "Season 1": [
            "Episode 1: Red Light, Green Light": [
                ["Alanna Zhou", "@alanna", "https://ca.slack-edge.com/T02A2C679-UNM3E26BF-6cbf92410a3b-192"],
                ["Renee Hoh", "@renee", "https://ca.slack-edge.com/T02A2C679-UNM3E26BF-6cbf92410a3b-192"]
            ],
            "Episode 4: Lights Out": [
                ["Vivi Ye", "@vivi", "https://ca.slack-edge.com/T02A2C679-UNM3E26BF-6cbf92410a3b-192"],
                ["Cindy Huang", "@cindy", "https://ca.slack-edge.com/T02A2C679-UNM3E26BF-6cbf92410a3b-192"],
            ],
            "Episode 6: Gganbu": [
                ["Olivia Li", "@olivia", "https://ca.slack-edge.com/T02A2C679-UNM3E26BF-6cbf92410a3b-192"],
            ],
            "Episode 7: VIPS": [
                ["Haiying Weng", "@haiying", "https://ca.slack-edge.com/T02A2C679-UNM3E26BF-6cbf92410a3b-192"],
            ]
        ]
    ]

    // MARK: - Private View Vars
    private var episodesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Watch Progress"
        view.backgroundColor = .offWhite

        episodesTableView = UITableView(frame: .zero, style: .plain)
        episodesTableView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        episodesTableView.dataSource = self
        episodesTableView.delegate = self
        episodesTableView.backgroundColor = .clear
        episodesTableView.allowsMultipleSelection = false
        episodesTableView.isScrollEnabled = true
        episodesTableView.alwaysBounceVertical = true
        episodesTableView.bounces = true
        episodesTableView.showsVerticalScrollIndicator = false
        episodesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        episodesTableView.register(WatchProgressTableViewCell.self, forCellReuseIdentifier: WatchProgressTableViewCell.reuseIdentifier)
        episodesTableView.separatorStyle = .none
        view.addSubview(episodesTableView)
  
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           setupNavigationBar()
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
    
    @objc private func backButtonPressed() {
            navigationController?.popViewController(animated: true)
        }


    private func setupConstraints() {
        let verticalPadding: CGFloat = 11
        
        episodesTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

    }
}

extension WatchProgressListViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return progressList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchProgressTableViewCell.reuseIdentifier, for: indexPath) as? WatchProgressTableViewCell else { return UITableViewCell() }
        cell.configure(seasonName: Array(progressList.keys)[indexPath.row])
        return cell
    }

}
