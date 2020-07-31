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
    private var reviewView: MediaReviewView!
    private let criticRatingLabel = UILabel()
    private let friendRatingLabel = UILabel()
    private let rangeSlider = RangeSlider(frame: .zero)
    private let rangeSlider2 = RangeSlider(frame: .zero)
    private let commentView = UIView()
    private let commentSeparatorView = UIView()
    private let commentTextField = UITextField()
    private let sendCommentButton = UIButton()
    private let ratingsSeparatorView = UIView()
    private let thoughtsSeparatorView = UIView()


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
        view.addSubview(ratingsSeparatorView)

        reviewView = MediaReviewView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        contentView.addSubview(reviewView)

        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
        let time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.rangeSlider.trackHighlightTintColor = .gradientPurple
            self.rangeSlider.personalThumbImage = UIImage(named: "unlock")
        }
        view.addSubview(rangeSlider)

        rangeSlider2.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
        let time2 = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time2) {
            self.rangeSlider2.trackHighlightTintColor = .gradientPurple
            self.rangeSlider2.personalThumbImage = UIImage(named: "newList")
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
        commentTextField.textColor = .black
        commentTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        commentView.addSubview(commentTextField)

        sendCommentButton.setImage(UIImage(named: "send"), for: .normal)
        commentView.addSubview(sendCommentButton)

        setupConstraints()

    }

    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
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

        reviewView.snp.makeConstraints { make in
            make.top.equalTo(ratingsSeparatorView.snp.bottom).offset(12)
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

        thoughtsSeparatorView.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
            make.top.equalTo(rangeSlider2.snp.bottom).offset(20)
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

    }

    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: 0.9 * view.frame.height)
    }

}
