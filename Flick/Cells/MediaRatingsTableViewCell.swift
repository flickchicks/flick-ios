//
//  MediaRatingsTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/18/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class SliderView : UIView {

    var externalRating: CGFloat = 0
    var personalRating: CGFloat = 0

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 133, height: 8), cornerRadius: 4)
        UIColor.lightGray2.setFill()
        path.fill()

        UIColor.gradientPurple.setFill()
        let personalValuePosition = personalRating * 133
        let externalValuePosition = externalRating * 133
        let maxValuePosition = max(personalValuePosition, externalValuePosition)
        let rectPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: maxValuePosition, height: 8), cornerRadius: 4)
        rectPath.fill()
    }

}

class MediaRatingsTableViewCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let ratingsSeparatorView = UIView()
    private let friendRatingIndicatorLabel = UILabel()
    private let criticRatingIndicatorLabel = UILabel()
    private let friendsRatingsSliderView = SliderView()
    private let criticRatingsSliderView = SliderView()
    private let criticRatingLabel = UILabel()
    private let friendsRatingLabel = UILabel()

    private let criticsIconImageView = UIImageView()
    private let friendsIconImageView = UIImageView()
    private let personalIconImageView = UIImageView()

    private var previousLocation = CGPoint()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .movieWhite
        // Initialization code

        // Initialization code
        titleLabel.text = "Ratings"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .darkBlue
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        addSubview(titleLabel)

        ratingsSeparatorView.backgroundColor = .lightGray2
        addSubview(ratingsSeparatorView)

        criticRatingsSliderView.backgroundColor = .lightGray2
        criticRatingsSliderView.layer.cornerRadius = 4
        addSubview(criticRatingsSliderView)

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
        criticRatingLabel.font = .systemFont(ofSize: 12)
        criticRatingLabel.textColor = .mediumGray
        criticRatingLabel.numberOfLines = 0
        addSubview(criticRatingLabel)

        friendsRatingLabel.text = "Me, Lucy, and 4 others"
        friendsRatingLabel.font = .systemFont(ofSize: 12)
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
        let sliderSize = CGSize(width: 133, height: 8)
        let ratingIconSize = CGSize(width: 14, height: 14)
        let ratingIndictorSize = CGSize(width: 46, height: 20)
        let personalRatingIconSize = CGSize(width: 20, height: 20)

        ratingsSeparatorView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(ratingsSeparatorView.snp.bottom).offset(17)
        }

        criticRatingsSliderView.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(sliderSize)
        }

        friendsRatingsSliderView.snp.makeConstraints{ make in
            make.top.equalTo(criticRatingsSliderView.snp.bottom).offset(48)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(sliderSize)
            make.bottom.equalToSuperview().inset(25)
        }

        criticRatingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(criticRatingsSliderView)
            make.leading.equalTo(criticRatingsSliderView.snp.trailing).offset(75)
            make.trailing.equalToSuperview().inset(20)
        }

        friendsRatingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(friendsRatingsSliderView)
            make.leading.equalTo(friendsRatingsSliderView.snp.trailing).offset(75)
            make.trailing.equalToSuperview().inset(20)
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
            personalRating = CGFloat(mediaPersonalRating)
        }

        criticRatingsSliderView.externalRating = criticRating
        friendsRatingsSliderView.externalRating = friendRating
        friendsRatingsSliderView.personalRating = personalRating

        friendsIconImageView.snp.updateConstraints { update in
            update.centerX.equalTo(friendsRatingsSliderView.snp.leading).offset(friendRating * 133)
        }

        criticsIconImageView.snp.updateConstraints { update in
            update.centerX.equalTo(criticRatingsSliderView.snp.leading).offset(criticRating * 133)
        }

        criticRatingIndicatorLabel.snp.makeConstraints { update in
            update.centerX.equalTo(criticsIconImageView.snp.centerX)
        }

        friendRatingIndicatorLabel.snp.makeConstraints { update in
           update.centerX.equalTo(friendsIconImageView.snp.centerX)
        }

        personalIconImageView.snp.updateConstraints { update in
            update.centerX.equalTo(friendsRatingsSliderView.snp.leading).offset(personalRating * 133)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        let coord = personalIconImageView.frame.origin
        switch recognizer.state {
        case .began:
            break
        case .changed:
            var xCoord = recognizer.location(in: self).x
            if xCoord < 10 {
                xCoord = 10
            } else if xCoord > 143 {
                xCoord = 143
            }
            personalIconImageView.frame.origin = CGPoint(x: xCoord, y: coord.y)
            friendsRatingsSliderView.personalRating = xCoord / 133
            friendsRatingsSliderView.setNeedsDisplay()
        case .ended:
//            print(personalIconImageView.frame.origin)
            break
        default:
            break
        }
    }

}
