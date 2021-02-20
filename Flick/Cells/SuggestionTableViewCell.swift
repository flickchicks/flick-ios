//
//  SuggestionTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import Kingfisher

protocol SuggestionsDelegate: class {
    func likeSuggestion(index: Int)
}

class SuggestionTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let dateLabel = UILabel()
    private let likeButton = UIButton()
    private let mediaDurationLabel = UILabel()
    private let mediaImageView = UIImageView()
    private let mediaTitleLabel = UILabel()
    private let mediaDurationImageView = UIImageView()
    private let mediaYearLabel = UILabel()
    private let messageLabel = UILabel()
    private let movieIconImageView = UIImageView()
    private let notificationLabel = UILabel()
    private let profileImageView = UIImageView()
    private let releaseDateLabel = UILabel()
    private let spacerView = UIView()
    private let synopsisLabel = UILabel()
    private let tagsLabel = UILabel()

    // MARK: - Private Data Vars
    weak var delegate: SuggestionsDelegate?
    private var index: Int!


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .offWhite

        containerView.layer.backgroundColor = UIColor.movieWhite.cgColor
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        containerView.layer.shadowOpacity = 0.07
        containerView.layer.shadowOffset = .init(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.skeletonCornerRadius = 10
        contentView.addSubview(containerView)
        
        dateLabel.textAlignment = .right
        dateLabel.font = .systemFont(ofSize: 10)
        dateLabel.textColor = .mediumGray
        contentView.addSubview(dateLabel)

        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        profileImageView.layer.masksToBounds = true
        containerView.addSubview(profileImageView)

        notificationLabel.font = .systemFont(ofSize: 14)
        notificationLabel.textColor = .black
        notificationLabel.numberOfLines = 0
        containerView.addSubview(notificationLabel)

        messageLabel.font = .systemFont(ofSize: 12)
        messageLabel.textColor = .darkBlueGray2
        messageLabel.numberOfLines = 0
        containerView.addSubview(messageLabel)

        mediaImageView.layer.masksToBounds = true
        mediaImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        mediaImageView.layer.cornerRadius = 8
        containerView.addSubview(mediaImageView)

        likeButton.addTarget(self, action: #selector(likeSuggestion), for: .touchUpInside)
        contentView.addSubview(likeButton)

        mediaTitleLabel.font = .boldSystemFont(ofSize: 14)
        mediaTitleLabel.textColor = .black
        mediaTitleLabel.numberOfLines = 0
        contentView.addSubview(mediaTitleLabel)

        contentView.addSubview(movieIconImageView)

        releaseDateLabel.textColor = .mediumGray
        releaseDateLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(releaseDateLabel)

        spacerView.layer.cornerRadius = 1.5
        spacerView.layer.backgroundColor = UIColor.lightGray.cgColor
        contentView.addSubview(spacerView)

        tagsLabel.textColor = .mediumGray
        tagsLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(tagsLabel)

        synopsisLabel.font = .systemFont(ofSize: 10)
        synopsisLabel.textColor = .darkBlue
        synopsisLabel.numberOfLines = 0
        contentView.addSubview(synopsisLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        let mediaImageSize = CGSize(width: 60, height: 90)
        let padding = 12

        containerView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(padding)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        profileImageView.snp.makeConstraints { make in
           make.top.leading.equalTo(containerView).inset(padding)
           make.height.width.equalTo(40)
        }

        notificationLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }

        messageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(notificationLabel)
            make.top.equalTo(notificationLabel.snp.bottom).offset(padding)
        }

        mediaImageView.snp.makeConstraints { make in
            make.leading.equalTo(notificationLabel)
            make.size.equalTo(mediaImageSize)
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.bottom.equalTo(contentView).inset(padding)
        }

        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(mediaImageView)
            make.centerX.equalTo(profileImageView)
        }

        mediaTitleLabel.snp.makeConstraints { make in
           make.top.equalTo(mediaImageView)
           make.leading.equalTo(mediaImageView.snp.trailing).offset(padding)
           make.trailing.equalTo(containerView).inset(padding)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.height.equalTo(padding)
            make.trailing.equalTo(containerView).inset(padding)
            make.width.equalTo(30)
        }

//        spacerView.snp.makeConstraints { make in
//           make.centerY.equalTo(movieIconImageView)
//           make.leading.equalTo(releaseDateLabel.snp.trailing).offset(6)
//           make.width.height.equalTo(3)
//        }

        movieIconImageView.snp.makeConstraints { make in
            make.leading.equalTo(mediaTitleLabel)
            make.top.equalTo(mediaTitleLabel.snp.bottom).offset(10)
            make.height.width.equalTo(15)
        }

        releaseDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(movieIconImageView.snp.trailing).offset(5)
            make.centerY.equalTo(movieIconImageView)
        }

//        tagsLabel.snp.makeConstraints { make in
//           make.leading.equalTo(spacerView.snp.trailing).offset(6)
//           make.centerY.equalTo(movieIconImageView)
//           make.trailing.equalTo(containerView).inset(padding)
//        }

        synopsisLabel.snp.makeConstraints { make in
           make.leading.trailing.equalTo(mediaTitleLabel)
           make.top.equalTo(movieIconImageView.snp.bottom).offset(10)
           make.bottom.equalTo(mediaImageView)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func likeSuggestion() {
        delegate?.likeSuggestion(index: index)
    }

    func configure(with suggestion: Suggestion, index: Int) {
        self.index = index
        notificationLabel.attributedText =
            NSMutableAttributedString()
            .boldFont14(suggestion.fromUser.name)
            .normalFont14(" suggested a \(suggestion.show.isTv ? "TV show" : "movie").")
        if let profilePic = suggestion.fromUser.profilePic {
            profileImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePic, cacheKey: "userid-\(suggestion.fromUser.id)"))
        }
        messageLabel.text = suggestion.message
        mediaTitleLabel.text = suggestion.show.title
        if let posterImageUrl = URL(string: suggestion.show.posterPic ?? "") {
            mediaImageView.kf.setImage(with: posterImageUrl)
        } else {
            mediaImageView.image = UIImage(named: "defaultMovie")
        }
        if let tags = suggestion.show.tags?.map({ $0.name }) {
            tagsLabel.text = tags.joined(separator: ", ")
        }
        movieIconImageView.image = UIImage(named: suggestion.show.isTv ? "tv" : "film")
        releaseDateLabel.text = suggestion.show.dateReleased
        synopsisLabel.text = suggestion.show.plot
        let dateLabelText = Date().getDateLabelText(createdAt: suggestion.createdAt)
        dateLabel.text = dateLabelText
//        let heartImage = suggestion.liked ? "filledHeart" : "heart"
        likeButton.setImage(UIImage(named: "heart"), for: .normal)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        mediaImageView.image = nil
    }

}

