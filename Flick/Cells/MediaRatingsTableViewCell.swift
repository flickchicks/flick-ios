//
//  MediaRatingsTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/18/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol RatingDelegate: class {
    func rateMedia(userRating: Int)
}


class SliderView : UIView {
    var externalRating: CGFloat = 0
    var personalRating: CGFloat = 0
    var width: CGFloat!

    init(width: CGFloat) {
        super.init(frame: .zero)
        self.width = width
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: 8), cornerRadius: 4)
        UIColor.lightGray2.setFill()
        path.fill()

        UIColor.gradientPurple.setFill()
        let personalValuePosition = personalRating * width
        let externalValuePosition = externalRating * width
        let maxValuePosition = max(personalValuePosition, externalValuePosition)
        let rectPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: maxValuePosition, height: 8), cornerRadius: 4)
        rectPath.fill()
    }
}

class MediaRatingsTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let criticsIconImageView = UIImageView()
    private let criticRatingIndicatorLabel = UILabel()
    private let criticRatingLabel = UILabel()
    private var criticRatingsSliderView: SliderView!
    private let friendsIconImageView = UIImageView()
    private let friendRatingIndicatorLabel = UILabel()
    private let friendsRatingLabel = UILabel()
    private var friendsRatingsSliderView: SliderView!
    private let personalIconImageView = UIImageView()
    private let ratingsSeparatorView = UIView()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    weak var delegate: RatingDelegate?
    private var previousLocation = CGPoint()
    private let sliderWidth: CGFloat = 133

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .movieWhite

        titleLabel.text = "Ratings"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .darkBlue
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        addSubview(titleLabel)

        ratingsSeparatorView.backgroundColor = .lightGray2
        addSubview(ratingsSeparatorView)

        criticRatingsSliderView = SliderView(width: sliderWidth)
        criticRatingsSliderView.backgroundColor = .lightGray2
        criticRatingsSliderView.layer.cornerRadius = 4
        addSubview(criticRatingsSliderView)

        friendsRatingsSliderView = SliderView(width: sliderWidth)
        friendsRatingsSliderView.backgroundColor = .lightGray2
        friendsRatingsSliderView.layer.cornerRadius = 4
        addSubview(friendsRatingsSliderView)

        criticRatingIndicatorLabel.text = "Critics"
        criticRatingIndicatorLabel.layer.backgroundColor = UIColor.lightPurple.cgColor
        criticRatingIndicatorLabel.layer.cornerRadius = 4
        criticRatingIndicatorLabel.textAlignment = .center
        criticRatingIndicatorLabel.textColor = .gradientPurple
        criticRatingIndicatorLabel.font = .systemFont(ofSize: 10)
        addSubview(criticRatingIndicatorLabel)

        friendRatingIndicatorLabel.text = "Friends"
        friendRatingIndicatorLabel.layer.backgroundColor = UIColor.lightPurple.cgColor
        friendRatingIndicatorLabel.layer.cornerRadius = 4
        friendRatingIndicatorLabel.textAlignment = .center
        friendRatingIndicatorLabel.textColor = .gradientPurple
        friendRatingIndicatorLabel.font = .systemFont(ofSize: 10)
        addSubview(friendRatingIndicatorLabel)

        criticRatingLabel.text = "from Rotten Tomatoes and IMDb"
        criticRatingLabel.textAlignment = .right
        criticRatingLabel.font = .systemFont(ofSize: 12)
        criticRatingLabel.textColor = .mediumGray
        criticRatingLabel.numberOfLines = 0
        addSubview(criticRatingLabel)

        // TODO: Replace with actual raters
        friendsRatingLabel.text = "Me, Lucy, and 4 others"
        friendsRatingLabel.font = .systemFont(ofSize: 12)
        friendsRatingLabel.textAlignment = .right
        friendsRatingLabel.textColor = .mediumGray
        friendsRatingLabel.numberOfLines = 0
        addSubview(friendsRatingLabel)

        criticsIconImageView.image = UIImage(named: "star")
        addSubview(criticsIconImageView)

        friendsIconImageView.image = UIImage(named: "friendIcon")
        addSubview(friendsIconImageView)

        personalIconImageView.image = UIImage(named: "dunkirk")
        personalIconImageView.layer.cornerRadius = 10
        personalIconImageView.layer.masksToBounds = true
        personalIconImageView.clipsToBounds = true
        personalIconImageView.layer.borderColor = UIColor.gradientPurple.cgColor
        personalIconImageView.layer.borderWidth = 2
        personalIconImageView.isUserInteractionEnabled = true
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        personalIconImageView.addGestureRecognizer(panGestureRecognizer)
        addSubview(personalIconImageView)

        setupConstraints()
    }

    private func setupConstraints() {
        let horizontalPadding = 20
        let personalRatingIconSize = CGSize(width: 20, height: 20)
        let ratingIconSize = CGSize(width: 14, height: 14)
        let ratingIndictorSize = CGSize(width: 46, height: 20)
        let sliderSize = CGSize(width: sliderWidth, height: 8)

        ratingsSeparatorView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(2)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(ratingsSeparatorView.snp.bottom).offset(17)
        }

        criticRatingsSliderView.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.leading.equalToSuperview().inset(horizontalPadding)
            make.size.equalTo(sliderSize)
        }

        friendsRatingsSliderView.snp.makeConstraints{ make in
            make.top.equalTo(criticRatingsSliderView.snp.bottom).offset(48)
            make.leading.equalToSuperview().inset(horizontalPadding)
            make.size.equalTo(sliderSize)
            make.bottom.equalToSuperview().inset(25)
        }

        criticRatingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(criticRatingsSliderView)
            make.leading.equalTo(criticRatingsSliderView.snp.trailing).offset(75)
            make.trailing.equalToSuperview().inset(horizontalPadding)
        }

        friendsRatingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(friendsRatingsSliderView)
            make.leading.equalTo(friendsRatingsSliderView.snp.trailing).offset(75)
            make.trailing.equalToSuperview().inset(horizontalPadding)
        }

        friendsIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(friendsRatingsSliderView)
            make.centerX.equalTo(friendsRatingsSliderView.snp.leading)
            make.size.equalTo(ratingIconSize)
        }

        criticRatingIndicatorLabel.snp.makeConstraints { make in
            make.bottom.equalTo(criticRatingsSliderView.snp.top).offset(-9)
            make.centerX.equalTo(criticsIconImageView.snp.centerX)
            make.size.equalTo(ratingIndictorSize)
        }

        friendRatingIndicatorLabel.snp.makeConstraints { make in
            make.bottom.equalTo(friendsRatingsSliderView.snp.top).offset(-9)
            make.centerX.equalTo(friendsIconImageView.snp.centerX)
            make.size.equalTo(ratingIndictorSize)
        }

        criticsIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(criticRatingsSliderView)
            make.centerX.equalTo(criticRatingsSliderView.snp.leading)
            make.size.equalTo(ratingIconSize)
        }

        personalIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(friendsRatingsSliderView)
            make.centerX.equalTo(friendsRatingsSliderView.snp.leading)
            make.size.equalTo(personalRatingIconSize)
        }
    }

    func configure(with media: Media) {
        let ratingIndictorSize = CGSize(width: 46, height: 20)
        var imbdRating: CGFloat = 0
        var tomatoRating: CGFloat = 0
        var friendRating: CGFloat = 0

        if let mediaImbdRating = media.imbdRating {
            imbdRating = CGFloat(mediaImbdRating)
        }

        if let mediaTomatoRating = media.tomatoRating {
            tomatoRating = CGFloat(mediaTomatoRating)
        }

        let criticRating = (imbdRating + tomatoRating) / 2

        if let mediaFriendRating = media.friendsRating {
            friendRating = CGFloat(mediaFriendRating)
        }

        var personalRating: CGFloat = 0
        if let mediaPersonalRating = media.userRating {
            personalRating = CGFloat(mediaPersonalRating) / 10
        }

        criticRatingsSliderView.externalRating = criticRating
        friendsRatingsSliderView.externalRating = friendRating
        friendsRatingsSliderView.personalRating = personalRating

        criticRatingsSliderView.setNeedsDisplay()
        friendsRatingsSliderView.setNeedsDisplay()

        friendsIconImageView.snp.updateConstraints { update in
            update.centerX.equalTo(friendsRatingsSliderView.snp.leading).offset(friendRating * sliderWidth)
        }

        criticsIconImageView.snp.updateConstraints { update in
            update.centerX.equalTo(criticRatingsSliderView.snp.leading).offset(criticRating * sliderWidth)
        }

        if criticRating == 0 {
            criticRatingIndicatorLabel.snp.remakeConstraints { remake in
                remake.bottom.equalTo(criticRatingsSliderView.snp.top).offset(-9)
                remake.leading.equalTo(criticsIconImageView)
                remake.size.equalTo(ratingIndictorSize)
            }
        } else {
            criticRatingIndicatorLabel.snp.makeConstraints { update in
                update.centerX.equalTo(criticsIconImageView.snp.centerX)
            }
        }

        if friendRating == 0 {
            friendRatingIndicatorLabel.snp.remakeConstraints { remake in
                remake.bottom.equalTo(friendsRatingsSliderView.snp.top).offset(-9)
                remake.leading.equalTo(friendsIconImageView)
                remake.size.equalTo(ratingIndictorSize)
            }
        } else {
            friendRatingIndicatorLabel.snp.makeConstraints { update in
               update.centerX.equalTo(friendsIconImageView.snp.centerX)
            }
        }

        personalIconImageView.snp.updateConstraints { update in
            update.centerX.equalTo(friendsRatingsSliderView.snp.leading).offset(personalRating * sliderWidth)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func getSliderXPosition(_ xCoord: CGFloat) -> CGFloat {
        if xCoord < 10 {
            return 10
        } else if xCoord > 143 {
            return 143
        } else {
            return xCoord
        }
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let coord = personalIconImageView.frame.origin
        switch recognizer.state {
        case .began:
            sendHapticFeedback()
        case .changed:
            let xCoord = getSliderXPosition(recognizer.location(in: self).x)
            personalIconImageView.frame.origin = CGPoint(x: xCoord, y: coord.y)
            friendsRatingsSliderView.personalRating = xCoord / 133
            friendsRatingsSliderView.setNeedsDisplay()
        case .ended:
            let xCoord = getSliderXPosition(recognizer.location(in: self).x)
            let filledInSliderWidth = xCoord - 10
            let filledInSliderPercentage = filledInSliderWidth / 133
            let rating = Int((filledInSliderPercentage * 10).rounded(.down))
            sendHapticFeedback()
            delegate?.rateMedia(userRating: rating)
        default:
            break
        }
    }

    private func sendHapticFeedback() {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }

}
