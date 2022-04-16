//
//  WatchProgressListViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 4/15/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class WatchProgressListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    private var progressTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Watch Progress"
        
        progressTableView = UITableView(frame: .zero, style: .plain)
        progressTableView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        progressTableView.dataSource = self
        progressTableView.delegate = self
        progressTableView.backgroundColor = .clear
        progressTableView.allowsMultipleSelection = false
        progressTableView.isScrollEnabled = true
        progressTableView.alwaysBounceVertical = true
        progressTableView.bounces = true
        progressTableView.showsVerticalScrollIndicator = false
        progressTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        progressTableView.register(WatchProgressTableViewCell.self, forCellReuseIdentifier: EpisodeTableViewCell.reuseIdentifier)
        progressTableView.separatorStyle = .none
        view.addSubview(progressTableView)

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
