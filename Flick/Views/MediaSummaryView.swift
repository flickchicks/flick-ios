//
//  MediaSummaryView.swift
//  Flick
//
//  Created by Lucy Xu on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaSummaryView: UIView {

    // MARK: - Private View Vars
    private var platformCollectionView: SelfSizeCollectionView!
    private var summaryItemsCollectionView: SelfSizeCollectionView!
    private let summaryLabel = UILabel()
    private var tagsCollectionView: SelfSizeCollectionView!
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let platformCellReuseIdentifier = "PlatformCellReuseIdentifier"
    private let summaryInfoCellReuseIdentifier = "SummaryInfoCellReuseIdentifier"
    private let tagCellReuseIdentifier = "TagCellReuseIdentifier"

    // TODO: Update media with backend values
    private let mediaTitle = "Spiderman: Far From Home"
    private let mediaSummary = "In May 1940, Germany advanced into France, trapping Allied troops on the beaches of Dunkirk. Under air and ground cover from British and French forces, troops were slowly and methodically evacuated from the beach using every serviceable naval and civilian vessel that could be found. At the end of this heroic mission, 330,000 French, British, Belgian and Dutch soldiers were safely evacuated."
    private let summaryInfo = [
        MediaSummary(text: "1h 30", type: .duration),
        MediaSummary(type: .spacer),
        MediaSummary(text: "2019", type: .year),
        MediaSummary(type: .spacer),
        MediaSummary(text: "Released", type: .releaseStatus),
        MediaSummary(type: .spacer),
        MediaSummary(text: "PG-13", type: .rating),
        MediaSummary(type: .spacer),
        MediaSummary(text: "EN", type: .language),
        MediaSummary(type: .spacer),
        MediaSummary(text: "Quentin Tarantino", type: .director)
    ]
    private let tags = ["A", "Supefdsfrheros", "A", "Abc", "Actifasfsafon", "Supesfasfsdfrheros"]
    private let platforms = ["Netflix", "Hulu"]

    override init(frame: CGRect) {
        super.init(frame: .zero)

        titleLabel.text = mediaTitle
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .darkBlue
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        addSubview(titleLabel)

        let summaryItemsCollectionViewLayout = LeftAlignedFlowLayout()
        summaryItemsCollectionView = SelfSizeCollectionView(frame: .zero, collectionViewLayout: summaryItemsCollectionViewLayout)
        summaryItemsCollectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        summaryItemsCollectionView.backgroundColor = .clear
        summaryItemsCollectionView.register(MediaSummaryInfoCollectionViewCell.self, forCellWithReuseIdentifier: summaryInfoCellReuseIdentifier)
        summaryItemsCollectionView.dataSource = self
        summaryItemsCollectionView.delegate = self
        summaryItemsCollectionView.contentInsetAdjustmentBehavior = .always
        summaryItemsCollectionView.layoutIfNeeded()
        addSubview(summaryItemsCollectionView)

        summaryLabel.text = mediaSummary
        summaryLabel.font = .systemFont(ofSize: 14)
        summaryLabel.textColor = .darkBlue
        summaryLabel.numberOfLines = 0
        summaryLabel.sizeToFit()
        addSubview(summaryLabel)

        let tagsCollectionViewLayout = LeftAlignedFlowLayout()
        tagsCollectionView = SelfSizeCollectionView(frame: .zero, collectionViewLayout: tagsCollectionViewLayout)
        tagsCollectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        tagsCollectionView.backgroundColor = .clear
        tagsCollectionView.register(MediaTagCollectionViewCell.self, forCellWithReuseIdentifier: tagCellReuseIdentifier)
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        tagsCollectionView.allowsSelection = true
        tagsCollectionView.layoutIfNeeded()
        addSubview(tagsCollectionView)

        let platformFlowLayout = UICollectionViewFlowLayout()
        platformFlowLayout.minimumInteritemSpacing = 12

        platformCollectionView = SelfSizeCollectionView(frame: .zero, collectionViewLayout: platformFlowLayout)
        platformCollectionView.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        platformCollectionView.backgroundColor = .clear
        platformCollectionView.register(MediaTagCollectionViewCell.self, forCellWithReuseIdentifier: platformCellReuseIdentifier)
        platformCollectionView.dataSource = self
        platformCollectionView.delegate = self
        platformCollectionView.allowsSelection = true
        platformCollectionView.layoutIfNeeded()
        addSubview(platformCollectionView)

        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

        let verticalPadding = 12
        let horizontalPadding = 10

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding*2)
        }

        summaryItemsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(summaryItemsCollectionView.contentSize.height)
        }

        summaryLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(summaryItemsCollectionView.snp.bottom).offset(16)
        }

        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(tagsCollectionView.contentSize.height)
        }

        platformCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(platformCollectionView.contentSize.height)
        }
    }

}

extension MediaSummaryView: UICollectionViewDataSource, UICollectionViewDelegate {
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: summaryInfoCellReuseIdentifier, for: indexPath) as? MediaSummaryInfoCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: summaryInfo[indexPath.item])
            return cell
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

extension MediaSummaryView: UICollectionViewDelegateFlowLayout {
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
            switch summaryInfo[indexPath.item].type {
            case .spacer:
                return CGSize(width: 10, height: height)
            case .director:
                return CGSize(width: textWidth + 19, height: height)
            case .duration:
                return CGSize(width: textWidth + 19, height: height)
            case .rating:
                return CGSize(width: textWidth + 8, height: 19)
            default:
                return CGSize(width: textWidth, height: 15)
            }
        } else if collectionView == tagsCollectionView {
            return CGSize(width: calculateNecessaryWidth(text: tags[indexPath.item]) + 32, height: 27)
        } else {
            return CGSize(width: 26, height: 26)
        }
    }
}
