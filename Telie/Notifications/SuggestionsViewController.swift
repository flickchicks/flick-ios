//
//  SuggestionsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

class SuggestionsViewController: UIViewController {

    // MARK: - Private View Vars
    private let emptyStateView = EmptyStateView(type: .suggestions)
    private let suggestionsTableView = UITableView(frame: .zero)
    private let refreshControl = UIRefreshControl()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 30, height: 30),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    
    // MARK: - Private Data Vars
    private var suggestions: [Suggestion] = []
    private let suggestionCellReuseIdentifier = "SuggestionCellReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .offWhite
        
        refreshControl.addTarget(self, action: #selector(refreshSuggestionData), for: .valueChanged)
        refreshControl.tintColor = .gradientPurple
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

        suggestionsTableView.isHidden = true
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

        view.addSubview(spinner)
        spinner.startAnimating()
        
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

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func refreshSuggestionData() {
        getSuggestions()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getSuggestions()
    }
    
    private func getSuggestions() {
        NetworkManager.getSuggestions { [weak self] suggestions in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.suggestions = suggestions
                let hasSuggestions = suggestions.count > 0
                self.emptyStateView.isHidden = hasSuggestions
                self.suggestionsTableView.isHidden = !hasSuggestions
                self.suggestionsTableView.reloadData()
                self.updateSuggestionViewedTime()
                self.refreshControl.endRefreshing()
                self.spinner.stopAnimating()
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
        cell.configure(with: suggestions[indexPath.row])
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let suggestion = suggestions[indexPath.row]
        let mediaViewController = MediaAllReactionsViewController(mediaId: suggestion.show.id, mediaName: suggestion.show.title)
        navigationController?.pushViewController(mediaViewController, animated: true)
        AnalyticsManager.logSelectContent(
            contentType: SelectContentType.Notification.suggestion,
            itemId: suggestion.id
        )
    }

}

extension SuggestionsViewController: SuggestionsDelegate {
    func likeSuggestion(suggestion: Suggestion) {
        NetworkManager.likeSuggestion(suggestionId: suggestion.id) { [weak self] success in
            guard let self = self else { return }
            if success {
                self.getSuggestions()
            }
        }
    }

    func pushProfileViewController(id: Int) {
        navigationController?.pushViewController(ProfileViewController(isHome: false, userId: id), animated: true)
    }
}

