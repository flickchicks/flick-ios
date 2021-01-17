//
//  SuggestionsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SkeletonView

class SuggestionsViewController: UIViewController {

    // MARK: - Private View Vars
    private let suggestionsTableView = UITableView(frame: .zero)

    // MARK: - Private Data Vars
    private var suggestions: [Suggestion] = []
    private let suggestionCellReuseIdentifier = "SuggestionCellReuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isSkeletonable = true
        view.backgroundColor = .offWhite

        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.isScrollEnabled = true
        suggestionsTableView.isSkeletonable = true
        suggestionsTableView.backgroundColor = .offWhite
        suggestionsTableView.register(SuggestionTableViewCell.self, forCellReuseIdentifier: suggestionCellReuseIdentifier)
        suggestionsTableView.separatorStyle = .none
        suggestionsTableView.rowHeight = UITableView.automaticDimension
        suggestionsTableView.estimatedRowHeight = 140
        view.addSubview(suggestionsTableView)
        
        suggestionsTableView.showAnimatedSkeleton(usingColor: .lightPurple, animation: .none, transition: .crossDissolve(0.25))

        suggestionsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkManager.getSuggestions { [weak self] suggestions in
            guard let self = self else { return }
            self.suggestions = suggestions
            DispatchQueue.main.async {
                self.suggestionsTableView.reloadData()
                self.updateSuggestionViewedTime()
                self.suggestionsTableView.hideSkeleton()
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

extension SuggestionsViewController: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return suggestionCellReuseIdentifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 1
    }
    
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
