//
//  MediaSummaryTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/18/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaSummaryTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private var providersCollectionView: SelfSizingCollectionView!
    private let summaryLabel = UILabel()
    private var summaryItemsCollectionView: SelfSizingCollectionView!
    private let titleLabel = UILabel()
    private var tagsCollectionView: SelfSizingCollectionView!

    // MARK: - Private Data Vars
    private let iconSummaryInfoCellReuseIdentifier = "IconSummaryInfoCellReuseIdentifier"
    private let labelSummaryInfoCellReuseIdentifier = "LabelSummaryInfoCellReuseIdentifier"
    private let outlineSummaryInfoCellReuseIdentifier = "OutlineSummaryInfoCellReuseIdentifier"
    private let spacerSummaryInfoCellReuseIdentifier = "SpacerSummaryInfoCellReuseIdentifier"
    private let summaryInfoCellReuseIdentifier = "SummaryInfoCellReuseIdentifier"
    private let tagCellReuseIdentifier = "TagCellReuseIdentifier"
    private let providerCellReuseIdentifier = "ProviderCellReuseIdentifier"

    private var summaryInfo: [MediaSummary] = []
    private var tags: [Tag] = []
    private var providers: [Provider] = []

    static let reuseIdentifier = "MediaSummaryCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

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
        summaryItemsCollectionView.register(MediaSummarySpacerCollectionViewCell.self, forCellWithReuseIdentifier: spacerSummaryInfoCellReuseIdentifier)
        summaryItemsCollectionView.register(MediaSummaryIconLabelCollectionViewCell.self, forCellWithReuseIdentifier: iconSummaryInfoCellReuseIdentifier)
        summaryItemsCollectionView.register(MediaSummaryLabelCollectionViewCell.self, forCellWithReuseIdentifier: labelSummaryInfoCellReuseIdentifier)
        summaryItemsCollectionView.register(MediaSummaryAudienceLevelCollectionViewCell.self, forCellWithReuseIdentifier: outlineSummaryInfoCellReuseIdentifier)
        summaryItemsCollectionView.dataSource = self
        summaryItemsCollectionView.delegate = self
        summaryItemsCollectionView.layoutIfNeeded()
        addSubview(summaryItemsCollectionView)

        let tagsCollectionViewLayout = LeftAlignedFlowLayout()
        tagsCollectionView = SelfSizingCollectionView(
            frame: CGRect(x: 0, y: 0, width: frame.width, height: 0),
            collectionViewLayout: tagsCollectionViewLayout)
        tagsCollectionView.backgroundColor = .clear
        tagsCollectionView.register(MediaTagCollectionViewCell.self, forCellWithReuseIdentifier: tagCellReuseIdentifier)
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        tagsCollectionView.layoutIfNeeded()
        addSubview(tagsCollectionView)

        let providersFlowLayout = UICollectionViewFlowLayout()
        providersFlowLayout.minimumInteritemSpacing = 12
        providersCollectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: providersFlowLayout)
        providersCollectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        providersCollectionView.backgroundColor = .clear
        providersCollectionView.register(ProviderCollectionViewCell.self, forCellWithReuseIdentifier: providerCellReuseIdentifier)
        providersCollectionView.dataSource = self
        providersCollectionView.delegate = self
        providersCollectionView.layoutIfNeeded()
        addSubview(providersCollectionView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with media: Media) {
        titleLabel.text = media.title
        summaryLabel.text = media.plot
        if let tags = media.tags {
            self.tags = tags
        }
        var mediaSummaryInfo: [MediaSummary] = []
        if let duration = media.duration {
            mediaSummaryInfo.append(MediaSummary(text: duration.inHourMinute, type: .duration))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        if let releaseYear = media.dateReleased {
            mediaSummaryInfo.append(MediaSummary(text: String(releaseYear.prefix(4)), type: .releaseStatus))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        if let status = media.status {
            mediaSummaryInfo.append(MediaSummary(text: status , type: .releaseStatus))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        if let audienceLevel = media.audienceLevel {
            mediaSummaryInfo.append(MediaSummary(text: audienceLevel, type: .rating))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        if let language = media.language {
            mediaSummaryInfo.append(MediaSummary(text: language.uppercased(), type: .language))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        if let director = media.directors, director != "" {
            mediaSummaryInfo.append(MediaSummary(text: director, type: .director))
            mediaSummaryInfo.append(MediaSummary(type: .spacer))
        }
        mediaSummaryInfo.removeLast()
        summaryInfo = mediaSummaryInfo
        summaryItemsCollectionView.reloadData()
        tagsCollectionView.reloadData()
        providers = media.providers ?? []
        if !providers.isEmpty {
            providersCollectionView.reloadData()
        }
    }

    private func setupConstraints() {
        let horizontalPadding: CGFloat = 20
        let verticalPadding: CGFloat = 12

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
        }

        summaryItemsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }

        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryItemsCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
        }

        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
        }

        providersCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalToSuperview().inset(horizontalPadding)
        }
    }

}

extension MediaSummaryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == summaryItemsCollectionView {
            return summaryInfo.count
        } else if collectionView == tagsCollectionView {
            return tags.count
        } else {
            return providers.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == summaryItemsCollectionView {
            // Use different cells for each type because they're different enough that it doesn't make sense to try to reuse cells
            switch summaryInfo[indexPath.item].type {
            case .spacer:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: spacerSummaryInfoCellReuseIdentifier, for: indexPath) as? MediaSummarySpacerCollectionViewCell else { return UICollectionViewCell() }
                return cell
            case .director, .duration:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iconSummaryInfoCellReuseIdentifier, for: indexPath) as? MediaSummaryIconLabelCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: summaryInfo[indexPath.item])
                return cell
            case .rating:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: outlineSummaryInfoCellReuseIdentifier, for: indexPath) as? MediaSummaryAudienceLevelCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: summaryInfo[indexPath.item])
                return cell
            case .releaseStatus, .year, .language:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: labelSummaryInfoCellReuseIdentifier, for: indexPath) as? MediaSummaryLabelCollectionViewCell else { return UICollectionViewCell() }
                cell.configure(with: summaryInfo[indexPath.item])
                return cell
            }
        } else if collectionView == tagsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellReuseIdentifier, for: indexPath) as? MediaTagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: tags[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: providerCellReuseIdentifier, for: indexPath) as? ProviderCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(for: providers[indexPath.item])
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
            let iconSpacerWidth: CGFloat = 23
            switch summaryInfo[indexPath.item].type {
            case .spacer:
                return CGSize(width: 2, height: height)
            case .director:
                return CGSize(width: min(textWidth + iconSpacerWidth, collectionView.frame.width - iconSpacerWidth), height: height)
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
