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

    // TODO: Initialize with media summary information
    private var summaryView: MediaSummaryView!
    private var reviewView: MediaReviewView!

     let rangeSlider = RangeSlider(frame: .zero)
    let rangeSlider2 = RangeSlider(frame: .zero)

    private let criticRatingLabel = UILabel()
    private let friendRatingLabel = UILabel()

    // MARK: - Private Data Vars
    private let handleIndicatorViewSize = CGSize(width: 64, height: 5)

    private let commentView = UIView()
    private let commentSeparatorView = UIView()
    private let commentTextField = UITextField()
    private let sendCommentButton = UIButton()

    private var commentsTableView: UITableView!

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

        setupHandleArea()

        summaryView = MediaSummaryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        summaryView.sizeToFit()
        view.addSubview(summaryView)

        reviewView = MediaReviewView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        view.addSubview(reviewView)

        print(summaryView.intrinsicContentSize.height)

        criticRatingLabel.text = "from Rotten Tomatoes and IMDb"
        criticRatingLabel.font = .systemFont(ofSize: 12)
        criticRatingLabel.textColor = .mediumGray
        criticRatingLabel.numberOfLines = 0
        view.addSubview(criticRatingLabel)

        friendRatingLabel.text = "Me, Lucy, and 4 others"
        friendRatingLabel.font = .systemFont(ofSize: 12)
        friendRatingLabel.textColor = .mediumGray
        friendRatingLabel.numberOfLines = 0
        view.addSubview(friendRatingLabel)

        summaryView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(summaryView.intrinsicContentSize.height)
        }

        reviewView.snp.makeConstraints { make in
            make.top.equalTo(summaryView.snp.bottom).offset(37)
            make.leading.trailing.equalToSuperview()
        }

//        commentView.backgroundColor = .orange
//        commentView.layer.borderColor = UIColor.lightGray2.cgColor
//        commentView.layer.borderWidth = 2
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

//        commentView.snp.makeConstraints { make in
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(71)
//        }
//
//        commentTextField.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(16)
//            make.leading.equalToSuperview().offset(28)
//            make.trailing.equalToSuperview().inset(60)
//            make.bottom.equalToSuperview().inset(16)
//        }
//
//        sendCommentButton.snp.makeConstraints { make in
//            make.width.height.equalTo(24)
//            make.leading.equalTo(commentTextField.snp.trailing).offset(14)
//            make.centerY.equalTo(commentTextField)
//        }

        commentsTableView = UITableView(frame: .zero, style: .plain)
        commentsTableView.backgroundColor = .none
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.isScrollEnabled = true
        commentsTableView.alwaysBounceVertical = false
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 140
        commentsTableView.layer.zPosition = -1
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "commentsTableCell")
        commentsTableView.separatorStyle = .none
        view.addSubview(commentsTableView)

        view.addSubview(rangeSlider)
           rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)),
                                 for: .valueChanged)
           let time = DispatchTime.now() + 1
           DispatchQueue.main.asyncAfter(deadline: time) {
             self.rangeSlider.trackHighlightTintColor = .gradientPurple
            self.rangeSlider.thumbImage = UIImage(named: "star")
             self.rangeSlider.highlightedThumbImage = UIImage(named: "star")
           }

        view.addSubview(rangeSlider2)
        rangeSlider2.addTarget(self, action: #selector(rangeSliderValueChanged(_:)),
                              for: .valueChanged)
        let time2 = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time2) {
          self.rangeSlider2.trackHighlightTintColor = .gradientPurple
         self.rangeSlider2.thumbImage = UIImage(named: "star")
          self.rangeSlider2.highlightedThumbImage = UIImage(named: "star")
        }
        
    }

    private func setupHandleArea() {
        view.addSubview(handleArea)

        handleIndicatorView.layer.backgroundColor = UIColor.lightGray4.cgColor
        handleIndicatorView.layer.cornerRadius = 2
        view.addSubview(handleIndicatorView)

        handleArea.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(75)
        }

        handleIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(handleIndicatorViewSize)
            make.top.equalToSuperview().offset(12)
        }
    }

    override func viewDidLayoutSubviews() {

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

        commentsTableView.snp.makeConstraints { make in
            make.leading.equalTo(rangeSlider)
            make.trailing.equalTo(criticRatingLabel)
            make.top.equalTo(rangeSlider2.snp.bottom).offset(42)
            make.height.equalTo(100)
        }
    }


    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
      let values = "(\(rangeSlider.lowerValue) \(rangeSlider.upperValue))"
      print("Range slider value changed: \(values)")
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
