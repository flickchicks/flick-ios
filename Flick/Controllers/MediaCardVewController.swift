//
//  MediaCardVewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/16/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaCardViewController: UIViewController {

    let handleArea = UIView()
    private let handleIndicatorView = UIView()
    let mediaInformationTableView = UITableView(frame: .zero, style: .plain)
    private let commentAreaView = CommentAreaView()

    private let handleIndicatorViewSize = CGSize(width: 64, height: 5)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .movieWhite
        view.layer.cornerRadius = 36
        // Apply corner radius only to top left and bottom right corners
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        setupHandleArea()

        mediaInformationTableView.backgroundColor = .movieWhite
        mediaInformationTableView.allowsSelection = false
        mediaInformationTableView.delegate = self
        mediaInformationTableView.dataSource = self
        mediaInformationTableView.isScrollEnabled = false
        mediaInformationTableView.bounces = false
        mediaInformationTableView.separatorStyle = .none
        mediaInformationTableView.rowHeight = UITableView.automaticDimension
        mediaInformationTableView.estimatedRowHeight = 140
        mediaInformationTableView.setNeedsLayout()
        mediaInformationTableView.layoutIfNeeded()
        mediaInformationTableView.register(MediaSummaryTableViewCell.self, forCellReuseIdentifier: "MediaSummaryReuseIdentifier")
        mediaInformationTableView.register(MediaRatingsTableViewCell.self, forCellReuseIdentifier: "MediaRatingsReuseIdentifier")
        mediaInformationTableView.register(MediaThoughtsTableViewCell.self, forCellReuseIdentifier: "MediaThoughtsReuseIdentifier")
        view.addSubview(mediaInformationTableView)

        commentAreaView.delegate = self
        view.addSubview(commentAreaView)

        setupConstraints()

    }

    private func setupHandleArea() {
        view.addSubview(handleArea)
        handleIndicatorView.layer.backgroundColor = UIColor.lightGray4.cgColor
        handleIndicatorView.layer.cornerRadius = 2
        view.addSubview(handleIndicatorView)

        handleArea.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }

        handleIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(handleIndicatorViewSize)
            make.top.equalToSuperview().offset(12)
        }
    }

    private func setupConstraints() {
        mediaInformationTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(handleArea.snp.bottom).offset(20)
            make.bottom.equalTo(commentAreaView.snp.top)
        }

        commentAreaView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(71 + view.safeAreaInsets.bottom)
        }
    }

    func updateTableScroll(isScrollEnabled: Bool) {
        mediaInformationTableView.isScrollEnabled = isScrollEnabled
    }

}

extension MediaCardViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaSummaryReuseIdentifier", for: indexPath) as? MediaSummaryTableViewCell else {
                return UITableViewCell()
            }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaRatingsReuseIdentifier", for: indexPath) as? MediaRatingsTableViewCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaThoughtsReuseIdentifier", for: indexPath) as? MediaThoughtsTableViewCell else {
                return UITableViewCell()
            }
            return cell
        }
    }


}

extension MediaCardViewController: CommentDelegate {
    func likeComment(index: Int) {
//        comments[index].liked.toggle()
//        commentsTableView.reloadData()
    }

    func addComment(commentText: String) {
        let comment = Comment(name: "Lucy", comment: commentText, date: "1d", liked: false)
//        comments.insert(comment, at: 0)
//        commentsTableView.reloadData()
    }
}
