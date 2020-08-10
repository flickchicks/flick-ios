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
        Suggestion(
            fromUser: "Lucy Xu",
            message: "Hello, pls watch this movie! I really liked it when I watched it with my family.",
            media: Media(
                id: 1,
                title: "Media",
                posterPic: "",
                directors: "James Tarentino",
                isTv: true,
                dateReleased: "",
                status: "",
                language: "",
                duration: "",
                plot: "An orphaned boy enrolls in a school of wizardry, where he learns the truth about himself, his family and the terrible evil that haunts the magical world.",
                tags: [Tag(tagId: "2", tag: "K Drama")],
                seasons: "",
                audienceLevel: "",
                imbdRating: 3,
                friendsRating: 3,
                platforms: [],
                keywords: [],
                cast: ""),
            liked: true)
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
        let mediaViewController = MediaViewController()
        navigationController?.pushViewController(mediaViewController, animated: true)
    }

}

extension SuggestionsViewController: SuggestionsDelegate {
    func likeSuggestion(index: Int) {
        suggestions[index].liked.toggle()
        suggestionsTableView.reloadData()
    }
}
