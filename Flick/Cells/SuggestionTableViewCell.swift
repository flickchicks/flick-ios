//
//  SuggestionTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/8/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {

    private let containerView = UIView()
    private let notificationLabel = UILabel()
    private let messageLabel = UILabel()
    private let profileImageView = UIImageView()
    private let mediaImageView = UIImageView()
    private let mediaTitleLabel = UILabel()
    private let mediaDurationLabel = UILabel()
    private let mediaDurationImageView = UIImageView()
    private let mediaYearLabel = UILabel()
    private let heartImageView = UIImageView()
    private let synopsisLabel = UILabel()
    private let createdYearLabel = UILabel()
    private let movieIconImageView = UIImageView()
    private let tagsLabel = UILabel()
    private let spacerView = UIView()


    private let tags = ["Comedy", "Romance", "K Drama"]
    private let createdYear = "2019"
    private let synopsis = "In May 1940, Germany advanced into France, trapping Allied troops on the beaches of Dunkirk. Under air and ground cover from British and French forces, troops were slowly and methodically evacuated from the beach using every serviceable naval and civilian vessel that could be found. At the end of this heroic mission, 330,000 French, British, Belgian and Dutch soldiers were safely evacuated. 12345678"
    private let summaryInfo = [
        MediaSummary(text: "1h 30", type: .duration),
        MediaSummary(type: .spacer),
        MediaSummary(text: "2019", type: .year)
    ]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        backgroundColor = .offWhite

        // TODO: Double check shadow
        containerView.layer.backgroundColor = UIColor.movieWhite.cgColor
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = .init(width: 1, height: 1)
        containerView.layer.shadowRadius = 2
        containerView.sizeToFit()
        contentView.addSubview(containerView)

        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        containerView.addSubview(profileImageView)

        notificationLabel.text = "Lucy Xu suggested a TV show."
        notificationLabel.font = .systemFont(ofSize: 14)
        notificationLabel.textColor = .black
        notificationLabel.numberOfLines = 0
        containerView.addSubview(notificationLabel)

        messageLabel.text = "You gotta watch this fam."
        messageLabel.font = .systemFont(ofSize: 12)
        messageLabel.textColor = .darkBlueGray2
        messageLabel.numberOfLines = 0
        containerView.addSubview(messageLabel)

        mediaImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        mediaImageView.layer.cornerRadius = 8
        containerView.addSubview(mediaImageView)

        heartImageView.image = UIImage(named: "heart")
        contentView.addSubview(heartImageView)

        mediaTitleLabel.text = "Crash Landing on You"
        mediaTitleLabel.font = .boldSystemFont(ofSize: 14)
        mediaTitleLabel.textColor = .black
        mediaTitleLabel.numberOfLines = 0
        contentView.addSubview(mediaTitleLabel)

        movieIconImageView.image = UIImage(named: "film")
        contentView.addSubview(movieIconImageView)

        createdYearLabel.text = createdYear
        createdYearLabel.textColor = .mediumGray
        createdYearLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(createdYearLabel)

        spacerView.layer.cornerRadius = 1
        spacerView.layer.backgroundColor = UIColor.lightGray.cgColor
        contentView.addSubview(spacerView)

        tagsLabel.text = tags.joined(separator: ", ")
        tagsLabel.textColor = .mediumGray
        tagsLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(tagsLabel)

        synopsisLabel.text = synopsis
        synopsisLabel.font = .systemFont(ofSize: 10)
        synopsisLabel.textColor = .darkBlue
        synopsisLabel.numberOfLines = 0
        contentView.addSubview(synopsisLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        let mediaImageSize = CGSize(width: 60, height: 90)

        containerView.snp.makeConstraints { make in
           make.top.equalTo(contentView).inset(12)
           make.bottom.equalToSuperview()
           make.leading.trailing.equalToSuperview().inset(20)
        }

        profileImageView.snp.makeConstraints { make in
           make.top.leading.equalTo(containerView).inset(12)
           make.height.width.equalTo(40)
        }

        notificationLabel.snp.makeConstraints { make in
           make.centerY.equalTo(profileImageView)
           make.leading.equalTo(profileImageView.snp.trailing).offset(12)
           make.trailing.equalToSuperview().inset(12)
        }

        messageLabel.snp.makeConstraints { make in
           make.leading.trailing.equalTo(notificationLabel)
           make.top.equalTo(notificationLabel.snp.bottom).offset(11.5)
        }

        mediaImageView.snp.makeConstraints { make in
           make.leading.equalTo(notificationLabel)
           make.size.equalTo(mediaImageSize)
           make.top.equalTo(messageLabel.snp.bottom).offset(16)
           make.bottom.equalTo(contentView).inset(12)
        }

        heartImageView.snp.makeConstraints { make in
           make.centerY.equalTo(mediaImageView)
           make.centerX.equalTo(profileImageView)
        }

        mediaTitleLabel.snp.makeConstraints { make in
           make.top.equalTo(mediaImageView)
           make.leading.equalTo(mediaImageView.snp.trailing).offset(12)
           make.trailing.equalTo(containerView).inset(12)
        }

        spacerView.snp.makeConstraints { make in
           make.centerY.equalTo(movieIconImageView)
           make.leading.equalTo(createdYearLabel.snp.trailing).offset(6)
           make.width.height.equalTo(2)
        }

        movieIconImageView.snp.makeConstraints { make in
            make.leading.equalTo(mediaTitleLabel)
            make.top.equalTo(mediaTitleLabel.snp.bottom).offset(10)
            make.height.width.equalTo(15)
        }

        createdYearLabel.snp.makeConstraints { make in
            make.leading.equalTo(movieIconImageView.snp.trailing).offset(5)
            make.centerY.equalTo(movieIconImageView)
        }

        tagsLabel.snp.makeConstraints { make in
           make.leading.equalTo(spacerView.snp.trailing).offset(6)
           make.centerY.equalTo(movieIconImageView)
           make.trailing.equalTo(containerView).inset(12)
        }

        synopsisLabel.snp.makeConstraints { make in
           make.leading.trailing.equalTo(mediaTitleLabel)
           make.top.equalTo(movieIconImageView.snp.bottom).offset(10)
           make.bottom.equalTo(mediaImageView)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

