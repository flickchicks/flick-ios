//
//  SuggestionsViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController {

    private let suggestionsTableView = UITableView(frame: .zero)
    private let suggestions: [Suggestion] = [
        Suggestion(fromUser: "Lucy Xu", message: "Hello, pls watch", media: Media(id: 1, title: "Media", posterPic: "", directors: "James Tarentino", isTv: true, dateReleased: "", status: "", language: "", duration: "", plot: "", tags: [Tag(tagId: "2", tag: "K Drama")], seasons: "", audienceLevel: "", imbdRating: 3, friendsRating: 3, platforms: [], keywords: [], cast: ""), liked: true),
        Suggestion(fromUser: "Haiying Weng", message: "Hello, pls watch", media: Media(id: 1, title: "Media", posterPic: "", directors: "James Tarentino", isTv: true, dateReleased: "", status: "", language: "", duration: "", plot: "", tags: [Tag(tagId: "2", tag: "K Drama")], seasons: "", audienceLevel: "", imbdRating: 3, friendsRating: 3, platforms: [], keywords: [], cast: ""), liked: false),
        Suggestion(fromUser: "Alanna Zhou", message: "Hello, pls watch", media: Media(id: 1, title: "Media", posterPic: "", directors: "James Tarentino", isTv: true, dateReleased: "", status: "", language: "", duration: "", plot: "", tags: [Tag(tagId: "2", tag: "K Drama")], seasons: "", audienceLevel: "", imbdRating: 3, friendsRating: 3, platforms: [], keywords: [], cast: ""), liked: true)
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
        suggestionsTableView.sizeToFit()
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
//        cell.configure(with: notifications[indexPath.row])
        return cell
    }


}
