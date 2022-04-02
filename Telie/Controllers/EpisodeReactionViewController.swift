//
//  EpisodeReactionViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 3/8/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class EpisodeReactionViewController: UIViewController {
    
    // MARK: - Private View Vars
    private var reactionsTableView: UITableView!
    
    
    // MARK: - Table View Sections
    private struct Section {
        let type: SectionType
    }

    private enum SectionType {
        case reaction
        case comments
    }
    
    // MARK: - Private Data Vars
    private var currentPosition = 0
    private var sections: [Section] = []
    private var reaction: Reaction

    init(reaction: Reaction) {
        self.reaction = reaction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        
        setupSections()
    
        reactionsTableView = UITableView(frame: .zero, style: .grouped)
        reactionsTableView.dataSource = self
        reactionsTableView.delegate = self
        reactionsTableView.backgroundColor = .clear
        reactionsTableView.allowsMultipleSelection = false
        reactionsTableView.alwaysBounceVertical = true
        reactionsTableView.bounces = true
        reactionsTableView.showsVerticalScrollIndicator = false
        reactionsTableView.register(ReactionsReactionTableViewCell.self, forCellReuseIdentifier: ReactionsReactionTableViewCell.reuseIdentifier)
        reactionsTableView.register(ReactionsCommentTableViewCell.self, forCellReuseIdentifier: ReactionsCommentTableViewCell.reuseIdentifier)
        reactionsTableView.isDirectionalLockEnabled = true
        reactionsTableView.separatorStyle = .none
        reactionsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        view.addSubview(reactionsTableView)
        
        let gradient = CAGradientLayer()
        gradient.frame = reactionsTableView.superview?.bounds ?? CGRect.null
        gradient.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear, UIColor.clear]
        gradient.locations = [0.0, 0.5, 0.95, 1.0]
        reactionsTableView.superview?.layer.mask = gradient
        reactionsTableView.backgroundColor = UIColor.clear
        
        setupConstraints()
    }
    
    private func setupSections() {
        let reactionSection = Section(type: .reaction)
        let commentsSection = Section(type: .comments)
        sections = [reactionSection, commentsSection]
    }

    private func setupConstraints() {
        reactionsTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension EpisodeReactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = sections[section]
        let headerView = UIView()
        switch section.type {
        
        case .reaction:
            headerView.backgroundColor = .clear
            return headerView
        case .comments:
            headerView.backgroundColor = .clear
            let headerLabel = UILabel()
            headerLabel.textColor = .lightGray
            headerLabel.font = .systemFont(ofSize: 12, weight: .medium)
            headerLabel.text = "\(reaction.thoughts?.count ?? 0) thoughts"
            headerView.addSubview(headerLabel)
            headerLabel.snp.makeConstraints { make in
                make.leading.bottom.equalToSuperview().inset(20)
            }
            let dividerView = UIView()
            dividerView.backgroundColor = .lightGray2
            headerView.addSubview(dividerView)
            dividerView.snp.makeConstraints { make in
                make.leading.equalTo(headerLabel.snp.trailing).inset(-10)
                make.trailing.equalToSuperview().inset(20)
                make.height.equalTo(1)
                make.centerY.equalTo(headerLabel.snp.centerY)
            }
            return headerView
        }
        
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section.type {
        case .reaction:
            return 1
        case .comments:
            return reaction.thoughts?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section.type {
        case .reaction:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReactionsReactionTableViewCell.reuseIdentifier, for: indexPath) as? ReactionsReactionTableViewCell else { return UITableViewCell() }
            cell.configure(reaction: reaction)
            return cell
            
        case .comments:
            guard let thoughts = reaction.thoughts,
                    let cell = tableView.dequeueReusableCell(withIdentifier: ReactionsCommentTableViewCell.reuseIdentifier, for: indexPath) as? ReactionsCommentTableViewCell else { return UITableViewCell() }
            cell.configure(thought: thoughts[indexPath.row])
            return cell
        }
    }
}
