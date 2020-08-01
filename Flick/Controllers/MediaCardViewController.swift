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

class SelfSizingTableView: UITableView {

  override var contentSize:CGSize {
      didSet {
          self.invalidateIntrinsicContentSize()
      }
  }

  override var intrinsicContentSize: CGSize {
      self.layoutIfNeeded()
    return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
  }
}

class MediaCardViewController: UIViewController {

    // MARK: - Private View Vars
    let handleArea = UIView()
    private let handleIndicatorView = UIView()
    let scrollView = UIScrollView()
    private let contentView = UIView()
    private var summaryView: MediaSummaryView!
    private var reviewTitleLabel = UILabel()
    private let criticRatingLabel = UILabel()
    private let friendRatingLabel = UILabel()
    private let reviewerRatingSliderControl = RatingSliderControl(type: .reviewers)
    private let friendRatingSliderControl = RatingSliderControl(type: .friends)
    private let commentView = UIView()
    private let commentSeparatorView = UIView()
    private let commentTextField = UITextField()
    private let sendCommentButton = UIButton()
    private let ratingsSeparatorView = UIView()
    private let thoughtsSeparatorView = UIView()

    private var commentsTableView: UITableView!

    private var comments = [
        Comment(name: "Haiying W", comment: "In May 1940, Germany advanced into France, trapping Allied troops on the beaches of Dunkirk. Under air and ground cover from British and French forces, troops were slowly and methodically evacuated from the beach using every serviceable naval and civilian vessel that could be found. At the end of this heroic mission, 330,000 French, British, Belgian and Dutch soldiers were safely evacuated. 12345678", date: "1d", liked: true),
        Comment(name: "Aastha S", comment: "This is a test comment. This is a test comment. ", date: "3d", liked: false),
        Comment(name: "Haiying W", comment: "This is a test comment. This is a test comment. ", date: "4d", liked: true),
        Comment(name: "Haiying W", comment: "This is a test comment. This is a test comment. This is a test comment. This is a test comment. This is a test comment.", date: "4d", liked: true),
        Comment(name: "Haiying W", comment: "This is a test comment. This is a test comment. This is a test comment. This is a test comment. This is a test comment. This is a test comment. This is a test comment. This is a test comment.", date: "4d", liked: false)
    ]

    private let thoughtsTitleLabel = UILabel()
    private let seeAllButton = UIButton()

    private let numComments = 4

    // MARK: - Private Data Vars
    private let handleIndicatorViewSize = CGSize(width: 64, height: 5)

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

        scrollView.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        summaryView = MediaSummaryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        summaryView.sizeToFit()
        contentView.addSubview(summaryView)

        ratingsSeparatorView.backgroundColor = .lightGray2
        contentView.addSubview(ratingsSeparatorView)

        reviewTitleLabel.text = "Ratings"
        reviewTitleLabel.font = .boldSystemFont(ofSize: 18)
        reviewTitleLabel.textColor = .black
        contentView.addSubview(reviewTitleLabel)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.reviewerRatingSliderControl.externalValue = 0.8
        }
        view.addSubview(reviewerRatingSliderControl)

        friendRatingSliderControl.addTarget(self, action: #selector(ratingSliderValueChanged(_:)), for: .valueChanged)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.friendRatingSliderControl.externalValue = 0.3
        }
        view.addSubview(friendRatingSliderControl)

        criticRatingLabel.text = "from Rotten Tomatoes and IMDb"
        criticRatingLabel.font = .systemFont(ofSize: 12)
        criticRatingLabel.textColor = .mediumGray
        criticRatingLabel.numberOfLines = 0
        contentView.addSubview(criticRatingLabel)

        friendRatingLabel.text = "Me, Lucy, and 4 others"
        friendRatingLabel.font = .systemFont(ofSize: 12)
        friendRatingLabel.textColor = .mediumGray
        friendRatingLabel.numberOfLines = 0
        contentView.addSubview(friendRatingLabel)

        thoughtsSeparatorView.backgroundColor = .lightGray2
        view.addSubview(thoughtsSeparatorView)

        commentView.backgroundColor = .movieWhite

        commentSeparatorView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 2)
        commentSeparatorView.backgroundColor = .lightGray2
        commentView.addSubview(commentSeparatorView)
        commentView.layer.zPosition = 1
        view.addSubview(commentView)

        commentTextField.backgroundColor = .lightGray2
        commentTextField.layer.cornerRadius = 15
        commentTextField.placeholder = "Share thoughts"
        commentTextField.textColor = .black
        commentTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        commentView.addSubview(commentTextField)

        sendCommentButton.setImage(UIImage(named: "send"), for: .normal)
        sendCommentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        commentView.addSubview(sendCommentButton)

        thoughtsTitleLabel.text = "Thoughts"
        thoughtsTitleLabel.font = .boldSystemFont(ofSize: 18)
        thoughtsTitleLabel.textColor = .black
        contentView.addSubview(thoughtsTitleLabel)

        seeAllButton.setTitle("See All \(numComments)", for: .normal)
        seeAllButton.contentHorizontalAlignment = .right
        seeAllButton.addTarget(self, action: #selector(seeAllComments), for: .touchUpInside)
        seeAllButton.setTitleColor(.darkBlueGray2, for: .normal)
        seeAllButton.titleLabel?.font = .systemFont(ofSize: 12)
        scrollView.addSubview(seeAllButton)

        commentsTableView = UITableView(frame: .zero)
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.backgroundColor = .none
        commentsTableView.isScrollEnabled = false
        commentsTableView.alwaysBounceVertical = false
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentsTableCell")
        commentsTableView.separatorStyle = .none
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 140
        commentsTableView.sizeToFit()
        view.addSubview(commentsTableView)
        
        setupConstraints()

    }

    @objc func seeAllComments() {
        let commentsViewController = MediaCommentsViewController(comments: comments)
        navigationController?.pushViewController(commentsViewController, animated: true)
    }

    @objc func addComment() {
        if let commentText = commentTextField.text, commentText.trimmingCharacters(in: .whitespaces) != "" {
            let comment = Comment(name: "Lucy", comment: commentText, date: "1d", liked: false)
            comments.insert(comment, at: 0)
            commentsTableView.reloadData()
        }
    }

    @objc func ratingSliderValueChanged(_ ratingSliderControl: RatingSliderControl) {
    }

    private func setupConstraints() {

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
            make.bottom.equalTo(commentView.snp.top)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }

        summaryView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(summaryView.intrinsicContentSize.height)
        }

        ratingsSeparatorView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
            make.top.equalTo(summaryView.snp.bottom).offset(20)
        }

        reviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingsSeparatorView.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        reviewerRatingSliderControl.snp.makeConstraints { make in
            make.top.equalTo(reviewTitleLabel.snp.bottom).offset(45)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(16)
            make.width.equalTo(133)
        }

        friendRatingSliderControl.snp.makeConstraints { make in
            make.top.equalTo(reviewerRatingSliderControl.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(16)
            make.width.equalTo(133)
        }

        criticRatingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reviewerRatingSliderControl)
            make.leading.equalTo(reviewerRatingSliderControl.snp.trailing).offset(75)
            make.trailing.equalToSuperview().inset(20)
        }

        friendRatingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(friendRatingSliderControl)
            make.leading.equalTo(friendRatingSliderControl.snp.trailing).offset(75)
            make.trailing.equalToSuperview().inset(20)
        }

        thoughtsSeparatorView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
            make.top.equalTo(friendRatingSliderControl.snp.bottom).offset(25)
        }

        commentView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(71 + view.safeAreaInsets.bottom)
        }

        commentTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().inset(60)
            make.bottom.equalToSuperview().inset(16)
        }

        sendCommentButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalTo(commentTextField.snp.trailing).offset(14)
            make.centerY.equalTo(commentTextField)
        }

        thoughtsTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(thoughtsSeparatorView.snp.bottom).offset(17)
            make.height.equalTo(22)
            make.width.equalTo(83)
        }

        seeAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(thoughtsTitleLabel)
            make.height.equalTo(15)
            make.leading.equalTo(thoughtsTitleLabel.snp.trailing)
        }

        commentsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(thoughtsTitleLabel.snp.bottom).offset(16)
            make.bottom.equalTo(commentView.snp.top)
//            make.height.equalTo(commentsTableView.contentSize.height)
        }

    }

    override func viewDidLayoutSubviews() {
        let summaryViewHeight = summaryView.intrinsicContentSize.height
        let reviewViewHeight: CGFloat = 173
        let commentsTableViewHeight = commentsTableView.contentSize.height
        let padding: CGFloat = 120
        let totalHeight = summaryViewHeight + reviewViewHeight + commentsTableViewHeight + padding
        scrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
    }

}

extension MediaCardViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentsTableCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
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
}
