//
//  MediaCardVewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/16/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaCardViewController: UIViewController {

    // MARK: - Public View Vars
    let handleArea = UIView()
    let mediaInformationTableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Private View Vars
    private let commentAreaView = CommentAreaView()
    private let handleIndicatorView = UIView()

    // MARK: - Private Data Vars
    private let handleIndicatorViewSize = CGSize(width: 64, height: 5)
    // Dummy Media Object (used before data is loaded)
    private var media: Media = Media(id: 0, title: "", posterPic: "", directors: "", isTv: true, dateReleased: "", status: "", language: "", duration: "", plot: "", tags: [], seasons: "", audienceLevel: "", imbdRating: 0, tomatoRating: 0, friendsRating: 0, userRating: 0, comments: [], platforms: [], keywords: [], cast: "")
    private let mediaSummaryReuseIdentifier = "MediaSummaryReuseIdentifier"
    private let mediaThoughtsReuseIdentifier = "MediaThoughtsReuseIdentifier"
    private let mediaRatingsReuseIdentifier = "MediaRatingsReuseIdentifier"

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
        mediaInformationTableView.register(MediaSummaryTableViewCell.self, forCellReuseIdentifier: mediaSummaryReuseIdentifier)
        mediaInformationTableView.register(MediaRatingsTableViewCell.self, forCellReuseIdentifier: mediaRatingsReuseIdentifier)
        mediaInformationTableView.register(MediaThoughtsTableViewCell.self, forCellReuseIdentifier: mediaThoughtsReuseIdentifier)
        view.addSubview(mediaInformationTableView)

        commentAreaView.delegate = self
        commentAreaView.sizeToFit()
        view.addSubview(commentAreaView)

        setupConstraints()

    }

    // Handle area triggers card pan gesture contrl
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
//            make.bottom.leading.trailing.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    // TODO: Fix scrolling and card pan gesture interactions
    func updateTableScroll(isScrollEnabled: Bool) {
        mediaInformationTableView.isScrollEnabled = isScrollEnabled
    }

    func setupMedia(media: Media) {
        self.media = media
        mediaInformationTableView.reloadData()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: mediaSummaryReuseIdentifier, for: indexPath) as? MediaSummaryTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: media)
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: mediaRatingsReuseIdentifier, for: indexPath) as? MediaRatingsTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: media)
            cell.delegate = self
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: mediaThoughtsReuseIdentifier, for: indexPath) as? MediaThoughtsTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: media)
            cell.delegate = self
            return cell
        }
    }
}

extension MediaCardViewController: CommentDelegate {
    func showSpoilerModal(commentText: String) {
        let commentSpoilerModalView = CommentSpoilerModalView(comment: commentText)
        commentSpoilerModalView.delegate = self
        commentSpoilerModalView.commentDelegate = self
        showModalPopup(view: commentSpoilerModalView)
    }

    func likeComment(index: Int) {
        let commentId = media.comments[index].id
        NetworkManager.likeComment(commentId: commentId) { comment in
            print("Like Success")
            //TODO: Reload thoughts table view cell comment
       }
    }

    func addComment(commentText: String, isSpoiler: Bool) {
        NetworkManager.postComment(mediaId: media.id, comment: commentText, isSpoiler: isSpoiler) { media in
            self.setupMedia(media: media)
        }
    }

    func seeAllComments() {
        let mediaCommentsViewController = MediaCommentsViewController(comments: media.comments, mediaId: media.id)
        navigationController?.pushViewController(mediaCommentsViewController, animated: true)
    }
}

extension MediaCardViewController: RatingDelegate {
    func rateMedia(userRating: Int) {
        NetworkManager.rateMedia(mediaId: media.id, userRating: userRating) { media in
            self.setupMedia(media: media)
        }
    }
}

extension MediaCardViewController: ModalDelegate {
    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

}
