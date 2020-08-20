//
//  MediaSummaryTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/18/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaSummaryTableViewCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let summaryLabel = UILabel()
    private var summaryItemsCollectionView: SelfSizingCollectionView!
    private var tagsCollectionView: SelfSizingCollectionView!
    private let summaryInfoCellReuseIdentifier = "SummaryInfoCellReuseIdentifier"
    private let tagCellReuseIdentifier = "TagCellReuseIdentifier"

    private var summaryInfo: [MediaSummary] = []

    private var tags: [MediaTag] = [MediaTag(id: 1, name: "Comedy"), MediaTag(id: 1, name: "Comedy"), MediaTag(id: 1, name: "Comedy"), MediaTag(id: 1, name: "Comedy"), MediaTag(id: 1, name: "Comedy"), MediaTag(id: 1, name: "Comedy")]

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
        summaryItemsCollectionView.register(MediaSummaryInfoCollectionViewCell.self, forCellWithReuseIdentifier: summaryInfoCellReuseIdentifier)
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
        return collectionView == summaryItemsCollectionView ? summaryInfo.count : tags.count
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
        } else {
            let totalHorizontalPadding: CGFloat = 32
            return CGSize(width: calculateNecessaryWidth(text: tags[indexPath.item].name) + totalHorizontalPadding, height: 27)
        }

    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        if collectionView == tagsCollectionView {
//            return 0
//        } else {
//            return 0
//        }
//    }
}
