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
    private let suggestionsTableView = UITableView(frame: .zero)

    // MARK: - Private Data Vars
    private var suggestions: [Suggestion] = [
        Suggestion(fromUser: "Lucy Xu", message: "Hello There", media: Media(id: 1, title: "fsf", posterPic: "fdf", directors: "fsdf", isTv: false, dateReleased: "fsdf", status: "fdsf", language: "fsdf", duration: "fsdfsdf", plot: "fsdf", tags: [], seasons: "fsdf", audienceLevel: "dss", imdbRating: 0, tomatoRating: 0, friendsRating: 0, userRating: 0, comments: [], platforms: [], keywords: [], cast: ""), liked: false)
    ]
    private let suggestionCellReuseIdentifier = "SuggestionCellReuseIdentifier"

    override func viewDidLoad() {
        view.backgroundColor = .offWhite

        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.isScrollEnabled = true
        suggestionsTableView.backgroundColor = .offWhite
        suggestionsTableView.register(SuggestionTableViewCell.self, forCellReuseIdentifier: suggestionCellReuseIdentifier)
        suggestionsTableView.separatorStyle = .none
        suggestionsTableView.rowHeight = UITableView.automaticDimension
        suggestionsTableView.estimatedRowHeight = 140
        view.addSubview(suggestionsTableView)

        suggestionsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        let mediaViewController = MediaViewController(mediaId: 1)
        navigationController?.pushViewController(mediaViewController, animated: true)
    }

}

extension SuggestionsViewController: SuggestionsDelegate {
    func likeSuggestion(index: Int) {
        suggestions[index].liked.toggle()
        suggestionsTableView.reloadData()
    }
}
