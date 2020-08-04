//
//  MediaCardViewController.swift
//  Flick
//
//  Created by Lucy Xu on 7/7/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import UIKit

enum CardState { case expanded, collapsed }

class MediaCardViewController: UIViewController {

    // MARK: - Private View Vars
    private let scollContentView = UIView()
    private let commentAreaView = CommentAreaView()
    private var commentsTableView: UITableView!
    private let criticRatingLabel = UILabel()
    private let friendRatingLabel = UILabel()
    private let friendRatingSliderControl = RatingSliderControl(type: .friends)
    let handleArea = UIView()
    private let handleIndicatorView = UIView()
    private let ratingsSeparatorView = UIView()
    private var reviewTitleLabel = UILabel()
    private let reviewerRatingSliderControl = RatingSliderControl(type: .reviewers)
    private let seeAllCommentsButton = UIButton()
    private let sendCommentButton = UIButton()
    let scrollView = UIScrollView()
    private var summaryView: MediaSummaryView!
    private let thoughtsSeparatorView = UIView()
    private let thoughtsTitleLabel = UILabel()

    // MARK: - Private Data Vars
    private let commentsCellReuseIdentifier = "CommentsTableCellReuseIdentifier"
    // TODO: Replace with backend values
    private var comments = [
        Comment(name: "Haiying W", comment: "In May 1940, Germany advanced into France, trapping Allied troops on the beaches of Dunkirk. Under air and ground cover from British and French forces, troops were slowly and methodically evacuated from the beach using every serviceable naval and civilian vessel that could be found. At the end of this heroic mission, 330,000 French, British, Belgian and Dutch soldiers were safely evacuated. 12345678", date: "1d", liked: true),
        Comment(name: "Aastha S", comment: "This is a test comment. This is a test comment. ", date: "3d", liked: false),
        Comment(name: "Haiying W", comment: "This is a test comment. This is a test comment. ", date: "4d", liked: true),
        Comment(name: "Haiying W", comment: "This is a test comment. This is a test comment. This is a test comment. This is a test comment. This is a test comment.", date: "4d", liked: true),
        Comment(name: "Haiying W", comment: "This is a test comment. This is a test comment. This is a test comment. This is a test comment. This is a test comment. This is a test comment. This is a test comment. This is a test comment.", date: "4d", liked: false)
    ]
    private let handleIndicatorViewSize = CGSize(width: 64, height: 5)
    private let numComments = 4

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .movieWhite
        view.layer.cornerRadius = 36
        // Apply corner radius only to top left and bottom right corners
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        view.addSubview(handleArea)
        handleIndicatorView.layer.backgroundColor = UIColor.lightGray4.cgColor
        handleIndicatorView.layer.cornerRadius = 2
        view.addSubview(handleIndicatorView)

        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.bounces = false
        view.addSubview(scrollView)

        scrollView.addSubview(scollContentView)
        scollContentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        summaryView = MediaSummaryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        summaryView.sizeToFit()
        scollContentView.addSubview(summaryView)

        ratingsSeparatorView.backgroundColor = .lightGray2
        scollContentView.addSubview(ratingsSeparatorView)

        reviewTitleLabel.text = "Ratings"
        reviewTitleLabel.font = .boldSystemFont(ofSize: 18)
        reviewTitleLabel.textColor = .black
        scollContentView.addSubview(reviewTitleLabel)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
             // Dispatch triggers the slider layers to be drawn
            self.reviewerRatingSliderControl.externalValue = 0.8
        }
        // Add to view instead of scollContentView because scrollView interferes with interactions
        view.addSubview(reviewerRatingSliderControl)

        friendRatingSliderControl.addTarget(self, action: #selector(ratingSliderValueChanged(_:)), for: .valueChanged)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            // Dispatch triggers the slider layers to be drawn
            self.friendRatingSliderControl.externalValue = 0.3
        }
        // Add to view instead of scollContentView because scrollView interferes with interactions
        view.addSubview(friendRatingSliderControl)

        criticRatingLabel.text = "from Rotten Tomatoes and IMDb"
        criticRatingLabel.font = .systemFont(ofSize: 12)
        criticRatingLabel.textColor = .mediumGray
        criticRatingLabel.numberOfLines = 0
        scollContentView.addSubview(criticRatingLabel)

        friendRatingLabel.text = "Me, Lucy, and 4 others"
        friendRatingLabel.font = .systemFont(ofSize: 12)
        friendRatingLabel.textColor = .mediumGray
        friendRatingLabel.numberOfLines = 0
        scollContentView.addSubview(friendRatingLabel)

        thoughtsSeparatorView.backgroundColor = .lightGray2
        scollContentView.addSubview(thoughtsSeparatorView)

        thoughtsTitleLabel.text = "Thoughts"
        thoughtsTitleLabel.font = .boldSystemFont(ofSize: 18)
        thoughtsTitleLabel.textColor = .black
        scollContentView.addSubview(thoughtsTitleLabel)

        seeAllCommentsButton.setTitle("See All \(numComments)", for: .normal)
        seeAllCommentsButton.contentHorizontalAlignment = .right
        seeAllCommentsButton.addTarget(self, action: #selector(seeAllComments), for: .touchUpInside)
        seeAllCommentsButton.setTitleColor(.darkBlueGray2, for: .normal)
        seeAllCommentsButton.titleLabel?.font = .systemFont(ofSize: 12)
        scollContentView.addSubview(seeAllCommentsButton)

        commentsTableView = UITableView(frame: .zero)
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.backgroundColor = .none
        commentsTableView.isScrollEnabled = false
        commentsTableView.alwaysBounceVertical = false
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: commentsCellReuseIdentifier)
        commentsTableView.separatorStyle = .none
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 140
        commentsTableView.sizeToFit()
        // Add to view instead of scollContentView because scrollView interferes with interactions
        view.addSubview(commentsTableView)

        commentAreaView.delegate = self
        view.addSubview(commentAreaView)
        
        setupConstraints()

    }

    @objc func seeAllComments() {
        let commentsViewController = MediaCommentsViewController(comments: comments)
        navigationController?.pushViewController(commentsViewController, animated: true)
    }

    @objc func ratingSliderValueChanged(_ ratingSliderControl: RatingSliderControl) {
    }

    private func setupConstraints() {

        let bottomSafeAreaInsets = view.safeAreaInsets.bottom
        let horizontalPadding = 20
        let sliderLabelPadding = 75
        let sliderSize = CGSize(width: 133, height: 16)
        let titleLabelPadding = 17

        handleArea.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }

        handleIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(handleIndicatorViewSize)
            make.top.equalToSuperview().offset(12)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(handleArea.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(commentAreaView.snp.top)
        }

        scollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        summaryView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(summaryView.intrinsicContentSize.height)
        }

        ratingsSeparatorView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(2)
            make.top.equalTo(summaryView.snp.bottom).offset(horizontalPadding)
        }

        reviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingsSeparatorView.snp.bottom).offset(titleLabelPadding)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
        }

        reviewerRatingSliderControl.snp.makeConstraints { make in
            make.top.equalTo(reviewTitleLabel.snp.bottom).offset(45)
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.size.equalTo(sliderSize)
        }

        friendRatingSliderControl.snp.makeConstraints { make in
            make.top.equalTo(reviewerRatingSliderControl.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.size.equalTo(sliderSize)
        }

        criticRatingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reviewerRatingSliderControl)
            make.leading.equalTo(reviewerRatingSliderControl.snp.trailing).offset(sliderLabelPadding)
            make.trailing.equalToSuperview().inset(horizontalPadding)
        }

        friendRatingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(friendRatingSliderControl)
            make.leading.equalTo(friendRatingSliderControl.snp.trailing).offset(sliderLabelPadding)
            make.trailing.equalToSuperview().inset(horizontalPadding)
        }

        thoughtsSeparatorView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(2)
            make.top.equalTo(friendRatingSliderControl.snp.bottom).offset(25)
        }

        commentAreaView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(71 + bottomSafeAreaInsets)
        }

        thoughtsTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalPadding)
            make.top.equalTo(thoughtsSeparatorView.snp.bottom).offset(titleLabelPadding)
            make.height.equalTo(22)
            make.width.equalTo(83)
        }

        seeAllCommentsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalTo(thoughtsTitleLabel)
            make.height.equalTo(15)
            make.leading.equalTo(thoughtsTitleLabel.snp.trailing)
        }

        commentsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(thoughtsTitleLabel.snp.bottom).offset(16)
            make.bottom.equalTo(commentAreaView.snp.top)
        }

    }

    override func viewDidLayoutSubviews() {
        let summaryViewHeight = summaryView.intrinsicContentSize.height
        let reviewViewHeight: CGFloat = 173 // Value taken from design
        let commentsTableViewHeight = commentsTableView.contentSize.height
        let padding: CGFloat = 135 // Value manually calculated, accounts for all other labels and padding
        let totalHeight = summaryViewHeight + reviewViewHeight + commentsTableViewHeight + padding
        scrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
    }

}

extension MediaCardViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: commentsCellReuseIdentifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        let comment = comments[indexPath.row]
        cell.configure(for: comment, index: indexPath.row, delegate: self)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let commentsViewController = MediaCommentsViewController(comments: comments)
        navigationController?.pushViewController(commentsViewController, animated: true)
    }

}

extension MediaCardViewController: CommentDelegate {
    func likeComment(index: Int) {
        comments[index].liked.toggle()
        commentsTableView.reloadData()
    }

    func addComment(commentText: String) {
        let comment = Comment(name: "Lucy", comment: commentText, date: "1d", liked: false)
        comments.insert(comment, at: 0)
        commentsTableView.reloadData()
    }
}
