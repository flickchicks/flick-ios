//
//  ListSummaryCollectionViewCell.swift
//  Flick
//
//  Created by HAIYING WENG on 6/13/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum tagDisplay { case condensed, expanded }

// To center collection view cells
// Reference: https://stackoverflow.com/a/49709185
class TagFlowLayout: UICollectionViewFlowLayout {

    required init(minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        sectionInsetReference = .fromSafeArea
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes }
        guard scrollDirection == .vertical else { return layoutAttributes }

        // Filter attributes to compute only cell attributes
        let cellAttributes = layoutAttributes.filter({ $0.representedElementCategory == .cell })

        // Group cell attributes by row (cells with same vertical center) and loop on those groups
        for (_, attributes) in Dictionary(grouping: cellAttributes, by: { ($0.center.y / 10).rounded(.up) * 10 }) {
            // Get the total width of the cells on the same row
            let cellsTotalWidth = attributes.reduce(CGFloat(0)) { (partialWidth, attribute) -> CGFloat in
                partialWidth + attribute.size.width
            }

            // Calculate the initial left inset
            let totalInset = collectionView!.safeAreaLayoutGuide.layoutFrame.width - cellsTotalWidth - sectionInset.left - sectionInset.right - minimumInteritemSpacing * CGFloat(attributes.count - 1)
            var leftInset = (totalInset / 2 * 10).rounded(.down) / 10 + sectionInset.left

            // Loop on cells to adjust each cell's origin and prepare leftInset for the next cell
            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }

        return layoutAttributes
    }

}

class ListSummaryCollectionViewCell: UICollectionViewCell {

    // MARK: - Private View Vars
    private let collaborateLabel = UILabel()
    private let collaborateView = UIView()
    private let listNameLabel = UILabel()
    private let privacyLabel = UILabel()
    private let privacyView = UIView()
    private var tagCollectionView: UICollectionView!

    // MARK: - Private Data Vars
    // TODO: Replace with data from backend
    private let allTags = ["Movie", "TV", "Drama", "Comedy", "RomanceRomance", "ActionAction", "Movie", "TV", "Drama", "Comedy", "Romance", "Action"]
    private var allTagSizes = [CGSize]()
    private var condensedTags = [String]()

    private let cellSpacing: CGFloat = 8
    private var numInFirstTwoRows = 0
    private var tagRowCount = 1
    private let tagCellReuseIdentifier = "TagCellReuseIdentifier"
    private var tagDisplay: tagDisplay = .expanded
    private var totalWidthPerRow: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .offWhite

        getAllTagSizes()

        // Temp
        let numCollaborator = 1
        let isPrivate = true

        let collaborateLabelText = numCollaborator == 1 ? "Only I" : "\(numCollaborator)"
        collaborateLabel.text = "\(collaborateLabelText) can edit"
        collaborateLabel.textColor = .mediumGray
        collaborateLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(collaborateView)
        collaborateView.addSubview(collaborateLabel)

        privacyLabel.text = isPrivate ? "Only I can view" : "Anyone can view"
        privacyLabel.textColor = .mediumGray
        privacyLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(privacyView)
        privacyView.addSubview(privacyLabel)

        listNameLabel.text = "Foreign Films" // Temp
        listNameLabel.textAlignment = .center
        listNameLabel.font = .boldSystemFont(ofSize: 20)
        contentView.addSubview(listNameLabel)

        let tagCollectionViewLayout = TagFlowLayout(
            minimumInteritemSpacing: cellSpacing,
            minimumLineSpacing: cellSpacing,
            sectionInset: UIEdgeInsets(top: 2, left: 30, bottom: 5, right: 30)
        )
        tagCollectionViewLayout.scrollDirection = .vertical
        tagCollectionViewLayout.sectionHeadersPinToVisibleBounds = true

        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tagCollectionViewLayout)
        tagCollectionView.backgroundColor = .offWhite
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: tagCellReuseIdentifier)
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        tagCollectionView.showsVerticalScrollIndicator = false
        tagCollectionView.showsHorizontalScrollIndicator = false
        tagCollectionView.bounces = false
        tagCollectionView.contentInsetAdjustmentBehavior = .always
        tagCollectionView.allowsSelection = true
        contentView.addSubview(tagCollectionView)

        setupConstraints()
    }

    private func setupConstraints() {
        collaborateLabel.snp.makeConstraints { make in
            make.edges.equalTo(collaborateView)
        }

        collaborateView.snp.makeConstraints { make in
            make.top.equalTo(listNameLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }

        privacyLabel.snp.makeConstraints { make in
            make.edges.equalTo(privacyView)
        }

        privacyView.snp.makeConstraints { make in
            make.top.equalTo(collaborateView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }

        listNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(22)
        }

        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(privacyView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }

    private func getAllTagSizes() {
        allTags.forEach { tag in
            let tagSize = tag.size(withAttributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)
            ])
            let width = tagSize.width + 24
            let height = tagSize.height + 12

            // To increment number of rows
            let collectionViewWidth = UIScreen.main.bounds.width - 60
            let cellWidth = width
            totalWidthPerRow += cellWidth + cellSpacing
            if (totalWidthPerRow > collectionViewWidth) {
                tagRowCount += 1
                totalWidthPerRow = cellWidth + cellSpacing
             }

            if tagRowCount <= 2 {
                numInFirstTwoRows += 1
            }
            allTagSizes.append(CGSize(width: width, height: height))
        }

        tagDisplay = numInFirstTwoRows != 0 && allTags.count > numInFirstTwoRows ? .condensed : .expanded
        if tagDisplay == .condensed {
            condensedTags = Array(allTags.prefix(numInFirstTwoRows - 1))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ListSummaryCollectionViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch tagDisplay {
        case .condensed:
            return condensedTags.count
        case .expanded:
            return allTags.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if tagDisplay == .condensed && indexPath.item == numInFirstTwoRows - 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellReuseIdentifier, for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(for: "+ \(allTags.count - numInFirstTwoRows + 2) more", type: .more)
                return cell
        } else {
            let tag = tagDisplay == .condensed ? condensedTags[indexPath.item] : allTags[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellReuseIdentifier, for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(for: tag, type: .tag)
            return cell
        }
    }

}

extension ListSummaryCollectionViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tagDisplay == .condensed && indexPath.item == condensedTags.count - 1 {
            tagDisplay = .expanded
            collectionView.reloadData()
        }
    }

}

extension ListSummaryCollectionViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return allTagSizes[indexPath.item]
    }

}
