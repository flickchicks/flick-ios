//
//  MediaSummaryTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/18/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaSummaryTableViewCell: UITableViewCell {

    private var platformCollectionView: SelfSizingCollectionView!
    private let titleLabel = UILabel()
    private let summaryLabel = UILabel()
    private var summaryItemsCollectionView: SelfSizingCollectionView!
    private var tagsCollectionView: SelfSizingCollectionView!
    private let summaryInfoCellReuseIdentifier = "SummaryInfoCellReuseIdentifier"
    private let tagCellReuseIdentifier = "TagCellReuseIdentifier"
    private let platformCellReuseIdentifier = "PlatformCellReuseIdentifier"

    private var summaryInfo: [MediaSummary] = []

    private var tags: [MediaTag] = [MediaTag(id: 1, name: "Comedy"), MediaTag(id: 1, name: "Comedy"), MediaTag(id: 1, name: "Comedy"), MediaTag(id: 1, name: "Comedy"), MediaTag(id: 1, name: "Comedy"), MediaTag(id: 1, name: "Comedy")]
    private let platforms = ["Netflix", "Hulu"]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .movieWhite

//        contentView.autoresizingMask = .flexibleHeight

        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .darkBlue
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        addSubview(titleLabel)

        summaryLabel.font = .systemFont(ofSize: 14)
        summaryLabel.textColor = .darkBlue
        summaryLabel.numberOfLines = 0
        summaryLabel.sizeToFit()
        addSubview(summaryLabel)

        let summaryItemsCollectionViewLayout = LeftAlignedFlowLayout()
        summaryItemsCollectionView = SelfSizingCollectionView(
            frame: CGRect(x: 0, y: 0, width: frame.width, height: 0),
            collectionViewLayout: summaryItemsCollectionViewLayout
        )
        summaryItemsCollectionView.backgroundColor = .clear
        summaryItemsCollectionView.register(MediaSummarySpacerCollectionViewCell.self, forCellWithReuseIdentifier: "spacer")
        summaryItemsCollectionView.register(MediaSummaryIconLabelCollectionViewCell.self, forCellWithReuseIdentifier: "icon")
        summaryItemsCollectionView.register(MediaSummaryLabelCollectionViewCell.self, forCellWithReuseIdentifier: "label")
        summaryItemsCollectionView.register(MediaSummaryAudienceLevelCollectionViewCell.self, forCellWithReuseIdentifier: "outline")
        summaryItemsCollectionView.dataSource = self
        summaryItemsCollectionView.delegate = self
        summaryItemsCollectionView.layoutIfNeeded()
        addSubview(summaryItemsCollectionView)

        let tagsCollectionViewLayout = LeftAlignedFlowLayout()
//        tagsCollectionViewLayout.minimumLineSpacing = 12
        tagsCollectionView = SelfSizingCollectionView(
            frame: CGRect(x: 0, y: 0, width: frame.width, height: 0),
            collectionViewLayout: tagsCollectionViewLayout)
        tagsCollectionView.backgroundColor = .clear
        tagsCollectionView.register(MediaTagCollectionViewCell.self, forCellWithReuseIdentifier: tagCellReuseIdentifier)
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        tagsCollectionView.layoutIfNeeded()
        addSubview(tagsCollectionView)

        let platformFlowLayout = UICollectionViewFlowLayout()
        platformFlowLayout.minimumInteritemSpacing = 12
        platformCollectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: platformFlowLayout)
        platformCollectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        platformCollectionView.backgroundColor = .clear
        platformCollectionView.register(MediaTagCollectionViewCell.self, forCellWithReuseIdentifier: platformCellReuseIdentifier)
        platformCollectionView.dataSource = self
        platformCollectionView.delegate = self
        platformCollectionView.layoutIfNeeded()
        addSubview(platformCollectionView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with media: Media) {
        titleLabel.text = media.title
        summaryLabel.text = media.plot
        tags = media.tags
        var mediaSummaryInfo: [MediaSummary] = []
        if let duration = media.duration {
            mediaSummaryInfo.append(MediaSummary(text: duration, type: .duration))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        if let releaseYear = media.dateReleased {
            mediaSummaryInfo.append(MediaSummary(text: releaseYear, type: .releaseStatus))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        if let audienceLevel = media.audienceLevel {
            mediaSummaryInfo.append(MediaSummary(text: audienceLevel, type: .rating))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        if let language = media.language {
            mediaSummaryInfo.append(MediaSummary(text: language, type: .language))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        if let director = media.directors {
            mediaSummaryInfo.append(MediaSummary(text: director, type: .director))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        mediaSummaryInfo.removeLast()
        summaryInfo = mediaSummaryInfo
        summaryItemsCollectionView.reloadData()
        tagsCollectionView.reloadData()
    }

    private func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        summaryItemsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryItemsCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        platformCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension MediaSummaryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == summaryItemsCollectionView {
            return summaryInfo.count
        } else if collectionView == tagsCollectionView {
            return tags.count
        } else {
            return platforms.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == summaryItemsCollectionView {
            switch summaryInfo[indexPath.item].type {
            case .spacer:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "spacer", for: indexPath) as? MediaSummarySpacerCollectionViewCell else { return UICollectionViewCell() }
                return cell
            case .director, .duration:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "icon", for: indexPath) as? MediaSummaryIconLabelCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: summaryInfo[indexPath.item])
                return cell
            case .rating:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outline", for: indexPath) as? MediaSummaryAudienceLevelCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: summaryInfo[indexPath.item])
                return cell
            case .releaseStatus, .year, .language:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "label", for: indexPath) as? MediaSummaryLabelCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: summaryInfo[indexPath.item])
                return cell
            }
        } else if collectionView == tagsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellReuseIdentifier, for: indexPath) as? MediaTagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: tags[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: platformCellReuseIdentifier, for: indexPath)
            cell.layer.cornerRadius = 5
            cell.layer.backgroundColor = UIColor.gray.cgColor
            return cell
        }
    }
}

extension MediaSummaryTableViewCell: UICollectionViewDelegateFlowLayout {
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
            case .director:
                return CGSize(width: textWidth + iconSpacerWidth, height: height)
            case .duration:
                return CGSize(width: textWidth + iconSpacerWidth, height: height)
            case .rating:
                return CGSize(width: textWidth + 8, height: height + 4)
            default:
                return CGSize(width: textWidth, height: height)
            }
        } else if collectionView == tagsCollectionView {
            let totalHorizontalPadding: CGFloat = 32
            return CGSize(width: calculateNecessaryWidth(text: tags[indexPath.item].name) + totalHorizontalPadding, height: 27)
        } else {
            return CGSize(width: 26, height: 26)
        }

    }

}