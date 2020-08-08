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
    private var summaryItemsCollectionView: SelfSizingCollectionView!
    private let summaryInfoCellReuseIdentifier = "SummaryInfoCellReuseIdentifier"
    private let tagCellReuseIdentifier = "TagCellReuseIdentifier"
    private let tags = ["Comedy", "Romance", "K Drama"]
    private var tagsCollectionView: SelfSizingCollectionView!

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

        let summaryItemsCollectionViewLayout = LeftAlignedFlowLayout()
        summaryItemsCollectionView = SelfSizingCollectionView(
            frame: CGRect(x: 0, y: 0, width: frame.width, height: 0),
            collectionViewLayout: summaryItemsCollectionViewLayout
        )
        summaryItemsCollectionView.backgroundColor = .clear
        summaryItemsCollectionView.register(MediaSummaryInfoCollectionViewCell.self, forCellWithReuseIdentifier: summaryInfoCellReuseIdentifier)
        summaryItemsCollectionView.dataSource = self
        summaryItemsCollectionView.delegate = self
        summaryItemsCollectionView.layoutIfNeeded()
        contentView.addSubview(summaryItemsCollectionView)

        let tagsCollectionViewLayout = LeftAlignedFlowLayout()
        tagsCollectionView = SelfSizingCollectionView(
            frame: CGRect(x: 0, y: 0, width: frame.width, height: 0),
            collectionViewLayout: tagsCollectionViewLayout)
        tagsCollectionView.backgroundColor = .clear
        tagsCollectionView.register(MediaTagCollectionViewCell.self, forCellWithReuseIdentifier: tagCellReuseIdentifier)
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        tagsCollectionView.layoutIfNeeded()
        contentView.addSubview(tagsCollectionView)

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
            make.top.equalTo(mediaImageView).offset(8)
            make.leading.equalTo(mediaImageView.snp.trailing).offset(12)
            make.trailing.equalTo(containerView).inset(12)
        }

        summaryItemsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(mediaTitleLabel)
            make.top.equalTo(mediaTitleLabel.snp.bottom).offset(10)
//            make.height.equalTo(summaryItemsCollectionView.contentSize.height)
        }

        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(summaryItemsCollectionView.snp.bottom).offset(11)
            make.leading.trailing.equalTo(mediaTitleLabel)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SuggestionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == summaryItemsCollectionView {
            return summaryInfo.count
        } else {
            return tags.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == summaryItemsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: summaryInfoCellReuseIdentifier, for: indexPath) as? MediaSummaryInfoCollectionViewCell else { return UICollectionViewCell() }
           cell.configure(with: summaryInfo[indexPath.item])
           return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellReuseIdentifier, for: indexPath) as? MediaTagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: tags[indexPath.item])
            return cell

        }
    }
}

extension SuggestionTableViewCell: UICollectionViewDelegateFlowLayout {
    func calculateNecessaryWidth(text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12)
        label.sizeToFit()
        return label.frame.width
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == summaryItemsCollectionView {
            let textWidth = calculateNecessaryWidth(text: summaryInfo[indexPath.item].text)
            let height: CGFloat = 15
            let iconSpacerWidth: CGFloat = 19
            switch summaryInfo[indexPath.item].type {
            case .spacer:
                return CGSize(width: 10, height: height)
            case .duration:
                return CGSize(width: textWidth + iconSpacerWidth, height: height)
            default:
                return CGSize(width: textWidth, height: height)
            }
        } else {
            let totalHorizontalPadding: CGFloat = 32
            return CGSize(width: calculateNecessaryWidth(text: tags[indexPath.item]) + totalHorizontalPadding, height: 27)
        }
    }
}
