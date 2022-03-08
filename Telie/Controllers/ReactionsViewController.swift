//
//  ReactionsViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 3/8/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class ReactionsViewController: UIViewController {
    var episodeNames: [String] = ["1. The Boy in the Iceberg", "2. The Avatar Returns", "3. The Southern Air Temple", "4. The Warriors of Kyoshi", "5. The King of Omashu", "6. Imprisoned", "7. Winter Solstice: Part 1: The Spirit World", "8. Winter Solstice: Part 2: Avatar Roku", "9. The Waterbending Scroll"]
    
    var reactionName: String = "Cindy"
    var reactionProfilePic: String = ""
    var reactionContent: String = "total was not expecting when they killed the old man TT i'm going to have an actual heart attack"

    
    var commentNames: [String] = ["Renee", "Renee", "Renee"]
    var commentProfilePics: [String] = ["", "", ""]
    var commentContent: [String] = [
        "let me tell you that shit ended meeeeeeeeeeeeeeeeeeeeeeeeee",
        "oops",
        "i need medication",
    ]

    // MARK: - Private View Vars
    private let moreInfoView = UIStackView()
    private var episodesTableView: UITableView!
    
    // MARK: - Table View Sections
    private struct Section {
        let type: SectionType
//        let header: String?
//        let hasFooter: Bool
//        var settingItems: [GroupSettingsType]
    }

    private enum SectionType {
        case reaction
        case comments
    }
    
    // MARK: - Data Vars
    private var sections: [Section] = []




    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Squid Game"
        view.backgroundColor = .offWhite
        
        setupSections()
        
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
        episodesTableView.register(EpisodeTableViewCell.self, forCellReuseIdentifier: EpisodeTableViewCell.reuseIdentifier)
        episodesTableView.register(ReactionsReactionTableViewCell.self, forCellReuseIdentifier: ReactionsReactionTableViewCell.reuseIdentifier)
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
    
    private func setupSections() {
        let reactionSection = Section(type: .reaction)
        let commentsSection = Section(type: .comments)
        sections = [reactionSection, commentsSection]
    }
    
    private func setupNavigationBar() {
            let backButtonSize = CGSize(width: 22, height: 18)
            let iconButtonSize = CGSize(width: 30, height: 30)

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
        
        let infoButton = UIButton()
        infoButton.setImage(UIImage(named: "infoIcon"), for: .normal)
        infoButton.tintColor = .black
        infoButton.snp.makeConstraints { make in
            make.size.equalTo(iconButtonSize)
        }

        infoButton.addTarget(self, action: #selector(iconButtonPressed), for: .touchUpInside)
        let infoButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoButtonItem
        
   
        
       
        
        }
    
    @objc private func backButtonPressed() {
            print("back button pressed")
            navigationController?.popViewController(animated: true)
        }
    
    @objc private func iconButtonPressed() {
            print("icon button pressed")
            navigationController?.popViewController(animated: true)
        }



    private func setupConstraints() {
//        let leadingTrailingPadding: CGFloat = 20
        let verticalPadding: CGFloat = 11

        episodesTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

    }
}

extension ReactionsViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .reaction:
            return 1
        case .comments:
            return commentContent.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .reaction:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReactionsReactionTableViewCell.reuseIdentifier, for: indexPath) as? ReactionsReactionTableViewCell else { return UITableViewCell() }
            cell.configure(reactionName: reactionName)
            return cell
            
        case .comments:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeTableViewCell.reuseIdentifier, for: indexPath) as? EpisodeTableViewCell else { return UITableViewCell() }
            cell.configure(episodeName: episodeNames[indexPath.row])
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeName = episodeNames[indexPath.row]
        print("clicked! \(episodeName)")
    }
}
