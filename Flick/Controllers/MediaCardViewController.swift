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
    let handleArea = UIView()
    private let handleIndicatorView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var summaryView: MediaSummaryView!
    private var reviewView: MediaReviewView!
    private let criticRatingLabel = UILabel()
    private let friendRatingLabel = UILabel()
    private let rangeSlider = RangeSlider(frame: .zero)
    private let rangeSlider2 = RangeSlider(frame: .zero)
    private let commentView = UIView()
    private let commentSeparatorView = UIView()
    private let commentTextField = UITextField()
    private let sendCommentButton = UIButton()
    private var commentsTableView: UITableView!


    // MARK: - Private Data Vars
    private let handleIndicatorViewSize = CGSize(width: 64, height: 5)
    private let comments = [
        Comment(name: "Haiying W", comment: "OMG best movie ever!!! I luv all the characters hehehe OMG best movie ever!!! I luv all the characters hehehe", date: "1d"),
        Comment(name: "Aastha S", comment: "Test comment", date: "3d"),
        Comment(name: "Haiying W", comment: "testfdsafasdfdsfadsf", date: "4d")
    ]

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

        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.frame = scrollView.bounds
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        summaryView = MediaSummaryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        summaryView.sizeToFit()
        contentView.addSubview(summaryView)

        reviewView = MediaReviewView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        contentView.addSubview(reviewView)

        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
        let time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.rangeSlider.trackHighlightTintColor = .gradientPurple
            self.rangeSlider.thumbImage = UIImage(named: "star")
            self.rangeSlider.highlightedThumbImage = UIImage(named: "star")
        }
        view.addSubview(rangeSlider)

        rangeSlider2.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
        let time2 = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time2) {
            self.rangeSlider2.trackHighlightTintColor = .gradientPurple
            self.rangeSlider2.thumbImage = UIImage(named: "star")
            self.rangeSlider2.highlightedThumbImage = UIImage(named: "star")
        }
        view.addSubview(rangeSlider2)

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

        commentView.backgroundColor = .movieWhite

        commentSeparatorView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 2)
        commentSeparatorView.backgroundColor = .lightGray2
        commentView.addSubview(commentSeparatorView)
        commentView.layer.zPosition = 1
        view.addSubview(commentView)

        commentTextField.backgroundColor = .lightGray2
        commentTextField.layer.cornerRadius = 15
        commentTextField.textColor = .black
        commentTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        commentView.addSubview(commentTextField)

        sendCommentButton.setImage(UIImage(named: "send"), for: .normal)
        commentView.addSubview(sendCommentButton)

        commentsTableView = UITableView(frame: .zero)
        commentsTableView.backgroundColor = .none
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.isScrollEnabled = false
        commentsTableView.alwaysBounceVertical = false
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 140
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentsTableCell")
        commentsTableView.separatorStyle = .none
        view.addSubview(commentsTableView)

        setupConstraints()

    }

    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        let values = "(\(rangeSlider.lowerValue) \(rangeSlider.upperValue))"
        print("Range slider value changed: \(values)")
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

        reviewView.snp.makeConstraints { make in
            make.top.equalTo(summaryView.snp.bottom).offset(37)
            make.leading.trailing.equalToSuperview()
        }

        rangeSlider.snp.makeConstraints { make in
            make.top.equalTo(reviewView.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(16)
            make.width.equalTo(133)
        }

        rangeSlider2.snp.makeConstraints { make in
            make.top.equalTo(rangeSlider.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(16)
            make.width.equalTo(133)
        }

        criticRatingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rangeSlider)
            make.leading.equalTo(rangeSlider.snp.trailing).offset(75)
            make.trailing.equalToSuperview().inset(20)
        }

        friendRatingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rangeSlider2)
            make.leading.equalTo(rangeSlider2.snp.trailing).offset(75)
            make.trailing.equalToSuperview().inset(20)
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

        commentsTableView.snp.makeConstraints { make in
            make.leading.equalTo(rangeSlider)
            make.trailing.equalTo(criticRatingLabel)
            make.top.equalTo(rangeSlider2.snp.bottom).offset(42)
            make.height.equalTo(100)
        }

    }

    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 1.5)
    }


}

extension MediaCardViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentsTableCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        let comment = comments[indexPath.row]
        cell.configure(for: comment)
        return cell
    }

}

