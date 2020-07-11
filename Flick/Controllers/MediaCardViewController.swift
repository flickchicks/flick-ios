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

class SelfSizeCollectionView: UICollectionView {

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        return self.collectionViewLayout.collectionViewContentSize
    }

}

class LeftAlignedFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let originalAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var leftMargin: CGFloat = 0.0
        var lastY: Int = 0
        return originalAttributes.map {
            let changedAttribute = $0
            // Check if start of a new row.
            // Center Y should be equal for all items on the same row
            if Int(changedAttribute.center.y.rounded()) != lastY {
                leftMargin = sectionInset.left
            }
            changedAttribute.frame.origin.x = leftMargin
            lastY = Int(changedAttribute.center.y.rounded())
            leftMargin += changedAttribute.frame.width + minimumInteritemSpacing
            return changedAttribute
        }
    }
}

class MediaCardViewController: UIViewController {

    // MARK: - Private View Vars
    let handleArea = UIView()
    private let handleIndicatorView = UIView()
    private let titleLabel = UILabel()
    private let summaryLabel = UILabel()
    private var summaryItemsCollectionView: SelfSizeCollectionView!
    private var tagsCollectionView: SelfSizeCollectionView!
    private var platformCollectionView: SelfSizeCollectionView!

    // MARK: - Private Data Vars
    private let handleIndicatorViewSize = CGSize(width: 64, height: 5)

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
    private let tags = ["Action", "Superheros", "Fantasy", "Action", "Superheros"]
    private let platforms = ["Netflix", "Hulu"]


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .movieWhite
        view.layer.cornerRadius = 36
        // Apply corner radius only to top left and bottom right corners
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        setupHandleArea()
        setupSummary()
        
    }

    private func setupHandleArea() {
        view.addSubview(handleArea)

        handleIndicatorView.layer.backgroundColor = UIColor.lightGray4.cgColor
        handleIndicatorView.layer.cornerRadius = 2
        view.addSubview(handleIndicatorView)

        handleArea.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(75)
        }

        handleIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(handleIndicatorViewSize)
            make.top.equalToSuperview().offset(12)
        }
    }

    private func setupSummary() {

        titleLabel.text = mediaTitle
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textColor = .darkBlue
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        view.addSubview(titleLabel)

        let tagCollectionViewLayout = LeftAlignedFlowLayout()
        let tagCollectionViewLayout2 = LeftAlignedFlowLayout()

        summaryItemsCollectionView = SelfSizeCollectionView(frame: .zero, collectionViewLayout: tagCollectionViewLayout2)
        summaryItemsCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: 0)
        summaryItemsCollectionView.backgroundColor = .clear
        summaryItemsCollectionView.register(MediaSummaryInfoCollectionViewCell.self, forCellWithReuseIdentifier: "SummaryCellReuseIdentifier")
        summaryItemsCollectionView.dataSource = self
        summaryItemsCollectionView.delegate = self
        summaryItemsCollectionView.showsVerticalScrollIndicator = false
        summaryItemsCollectionView.showsHorizontalScrollIndicator = false
        summaryItemsCollectionView.bounces = false
        summaryItemsCollectionView.contentInsetAdjustmentBehavior = .always
        summaryItemsCollectionView.layoutIfNeeded()
        view.addSubview(summaryItemsCollectionView)

        summaryLabel.text = mediaSummary
        summaryLabel.font = .systemFont(ofSize: 14)
        summaryLabel.textColor = .darkBlue
        summaryLabel.numberOfLines = 0
        summaryLabel.sizeToFit()
        view.addSubview(summaryLabel)

        tagsCollectionView = SelfSizeCollectionView(frame: .zero, collectionViewLayout: tagCollectionViewLayout)
        tagsCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: 0)
        tagsCollectionView.backgroundColor = .clear
        tagsCollectionView.register(MediaTagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCellReuseIdentifier")
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        tagsCollectionView.showsVerticalScrollIndicator = false
        tagsCollectionView.showsHorizontalScrollIndicator = false
        tagsCollectionView.bounces = false
        tagsCollectionView.contentInsetAdjustmentBehavior = .always
        tagsCollectionView.allowsSelection = true
        tagsCollectionView.layoutIfNeeded()
        view.addSubview(tagsCollectionView)

        let platformFlowLayout = UICollectionViewFlowLayout()
        platformFlowLayout.minimumInteritemSpacing = 12

        platformCollectionView = SelfSizeCollectionView(frame: .zero, collectionViewLayout: platformFlowLayout)
        platformCollectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 40, height: 0)
        platformCollectionView.backgroundColor = .clear
        platformCollectionView.register(MediaTagCollectionViewCell.self, forCellWithReuseIdentifier: "PlatformCellReuseIdentifier")
        platformCollectionView.dataSource = self
        platformCollectionView.delegate = self
        platformCollectionView.showsVerticalScrollIndicator = false
        platformCollectionView.showsHorizontalScrollIndicator = false
        platformCollectionView.bounces = false
        platformCollectionView.contentInsetAdjustmentBehavior = .always
        platformCollectionView.allowsSelection = true
        platformCollectionView.layoutIfNeeded()
        view.addSubview(platformCollectionView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
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
            make.top.equalTo(summaryLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(tagsCollectionView.contentSize.height)
        }

        platformCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(titleLabel)
            make.height.equalTo(platformCollectionView.contentSize.height)
        }

    }

}

extension MediaCardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SummaryCellReuseIdentifier", for: indexPath) as? MediaSummaryInfoCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: summaryInfo[indexPath.item])
            return cell
        } else if collectionView == tagsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCellReuseIdentifier", for: indexPath) as? MediaTagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(with: tags[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlatformCellReuseIdentifier", for: indexPath)
            cell.layer.cornerRadius = 5
            cell.layer.backgroundColor = UIColor.gray.cgColor
            return cell
        }
    }

}

extension MediaCardViewController: UICollectionViewDelegateFlowLayout {

    func calculateNecessaryWidth(text: String) -> CGFloat {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12)
        label.sizeToFit()
        return label.frame.width
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == summaryItemsCollectionView {
            switch summaryInfo[indexPath.item].type {
            case .spacer:
                return CGSize(width: 10, height: 15)
            case .director:
                return CGSize(width: calculateNecessaryWidth(text: summaryInfo[indexPath.item].text) + 19, height: 15)
            case .duration:
                return CGSize(width: calculateNecessaryWidth(text: summaryInfo[indexPath.item].text) + 19, height: 15)
            case .rating:
                return CGSize(width: calculateNecessaryWidth(text: summaryInfo[indexPath.item].text) + 8, height: 19)
            default:
                return CGSize(width: calculateNecessaryWidth(text: summaryInfo[indexPath.item].text), height: 15)
            }
        } else if collectionView == tagsCollectionView {
            return CGSize(width: calculateNecessaryWidth(text: tags[indexPath.item]) + 32, height: 27)
        } else {
            return CGSize(width: 26, height: 26)
        }
    }
}
