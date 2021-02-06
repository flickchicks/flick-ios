//
//  SuggestionsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController {

    // MARK: - Private View Vars
    private let emptyStateView = EmptyStateView(type: .suggestions)
    private let suggestionsTableView = UITableView(frame: .zero)
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Private Data Vars
    private var suggestions: [Suggestion] = []
    private let suggestionCellReuseIdentifier = "SuggestionCellReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .offWhite
        
        refreshControl.addTarget(self, action: #selector(refreshSuggestionData), for: .valueChanged)

        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.isScrollEnabled = true
        suggestionsTableView.showsVerticalScrollIndicator = false
        suggestionsTableView.backgroundColor = .offWhite
        suggestionsTableView.register(SuggestionTableViewCell.self, forCellReuseIdentifier: suggestionCellReuseIdentifier)
        suggestionsTableView.separatorStyle = .none
        suggestionsTableView.rowHeight = UITableView.automaticDimension
        suggestionsTableView.estimatedRowHeight = 140
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            suggestionsTableView.refreshControl = refreshControl
        } else {
            suggestionsTableView.addSubview(refreshControl)
        }
        
        view.addSubview(suggestionsTableView)
        
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        suggestionsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func refreshSuggestionData() {
        getSuggetions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getSuggetions()
    }
    
    private func getSuggetions() {
        NetworkManager.getSuggestions { [weak self] suggestions in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.suggestions = suggestions
                self.emptyStateView.isHidden = suggestions.count > 0
                self.suggestionsTableView.reloadData()
                self.updateSuggestionViewedTime()
                self.refreshControl.endRefreshing()
            }
        }
    }

    private func updateSuggestionViewedTime() {
        let currentTime = Date().iso8601withFractionalSeconds
        NetworkManager.updateSuggestionViewedTime(currentTime: currentTime) { success in
            if success {
                print("Updated suggestion viewed time")
            } else {
                print("Failed to update suggestion viewed time")
            }
        }
    }

}

extension SuggestionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: suggestionCellReuseIdentifier, for: indexPath) as? SuggestionTableViewCell else { return UITableViewCell() }
        cell.configure(with: suggestions[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let suggestion = suggestions[indexPath.row]
        let mediaViewController = MediaViewController(mediaId: suggestion.show.id, mediaImageUrl: suggestion.show.posterPic)
        navigationController?.pushViewController(mediaViewController, animated: true)
    }

}

extension SuggestionsViewController: SuggestionsDelegate {
    func likeSuggestion(index: Int) {
//        suggestions[index].liked.toggle()
//        suggestionsTableView.reloadData()
    }
}
