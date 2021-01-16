//
//  ListSummaryCollectionViewCell.swift
//  Flick
//
//  Created by HAIYING WENG on 6/13/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol ListSummaryDelegate: class {
    func changeListSummaryHeight(height: Int)
}

enum tagDisplay { case collapsed, expanded }

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
    private let collaboratorsPreviewView = UsersPreviewView(users: [], usersLayoutMode: .collaborators)
    private let lockView = UIImageView()
    private let privacyLabel = UILabel()
    private let privacyView = UIView()
    private let showLessButton = UIButton()
    private var tagCollectionView: UICollectionView!

    // MARK: - Private Data Vars
    private var allTags: [String] = []
    private var allTagSizes = [CGSize]()
    private var collapsedTags = [String]()
    private var collaborators: [UserProfile]!
    private var numInFirstTwoRows = 0
    private var selectedTagIndex: IndexPath?
    private let tagCellReuseIdentifier = "TagCellReuseIdentifier"
    private let tagCellSpacing: CGFloat = 8
    private var tagDisplay: tagDisplay = .collapsed
    private var tagRowCount = 1
    private var totalWidthPerRow: CGFloat = 0
    private var list: MediaList!

    private weak var delegate: ListSummaryDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .offWhite

        collaborateLabel.textColor = .mediumGray
        collaborateLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(collaborateView)
        collaborateView.addSubview(collaborateLabel)
        collaborateView.addSubview(collaboratorsPreviewView)

        privacyLabel.textColor = .mediumGray
        privacyLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(privacyView)
        privacyView.addSubview(privacyLabel)
        privacyView.addSubview(lockView)

        showLessButton.setTitle("Show less", for: .normal)
        showLessButton.setTitleColor(.mediumGray, for: .normal)
        showLessButton.titleLabel?.font = .systemFont(ofSize: 12)
        showLessButton.isHidden = true
        showLessButton.addTarget(self, action: #selector(tappedShowLess), for: .touchUpInside)
        contentView.addSubview(showLessButton)

        let tagCollectionViewLayout = TagFlowLayout(
            minimumInteritemSpacing: tagCellSpacing,
            minimumLineSpacing: tagCellSpacing,
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
        let listInfoHeight = 20
        let lockButtonSize = CGSize(width: 12, height: 16)

        privacyLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
        }
        
        lockView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.trailing.equalTo(privacyLabel.snp.leading).offset(-8)
            make.size.equalTo(lockButtonSize)
        }

        privacyView.snp.makeConstraints { make in
            make.top.equalTo(collaborateView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(listInfoHeight)
        }

        showLessButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tagCollectionView.snp.bottom).offset(10)
        }

        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(privacyView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }

        collaborateLabel.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
        }

        collaboratorsPreviewView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.trailing.equalTo(collaborateLabel.snp.leading).offset(-8)
            make.height.equalTo(listInfoHeight)
            make.width.equalTo(0) // Temporarily set as 0, but it will be updated when configuring the cell
        }

        collaborateView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(listInfoHeight)
        }
    }

    private func setupCollaborators(collaborators: [UserProfile]) {
        collaborateLabel.text = collaborators.count == 1 ? collaborators[0].name : Constants.Collaboration.numCanEdit(num: collaborators.count)
        collaboratorsPreviewView.users = collaborators

        let collaboratorsPreviewWidth = collaboratorsPreviewView.getUsersPreviewWidth()

        collaboratorsPreviewView.snp.updateConstraints { update in
            update.width.equalTo(collaboratorsPreviewWidth)
        }
    }

    func configure(list: MediaList?, delegate: ListSummaryDelegate) {
        guard let list = list else { return }
        self.list = list
        self.delegate = delegate
        self.allTags = list.tags.map { $0.name }

        getAllTagSizes()
        tagCollectionView.reloadData()

        collaborators = list.collaborators
        collaborators.insert(list.owner, at: 0)
        setupCollaborators(collaborators: collaborators)

        privacyLabel.text = list.isPrivate ? Constants.Privacy.privateList : Constants.Privacy.publicList
        lockView.image = UIImage(named: list.isPrivate ? "lock" : "unlock")
    }

    private func getAllTagSizes() {
        // Reset initial values
        numInFirstTwoRows = 0
        tagRowCount = 1
        totalWidthPerRow = 0

        // Get size of all tags
        allTags.forEach { tag in
            let tagSize = tag.size(withAttributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)
            ])
            let width = tagSize.width + 24
            let height = tagSize.height + 10

            // To increment number of rows
            let collectionViewWidth = UIScreen.main.bounds.width - 60
            let cellWidth = width
            totalWidthPerRow += cellWidth + tagCellSpacing
            if totalWidthPerRow > collectionViewWidth {
                tagRowCount += 1
                totalWidthPerRow = cellWidth + tagCellSpacing
             }

            if tagRowCount <= 2 {
                numInFirstTwoRows += 1
            }
            allTagSizes.append(CGSize(width: width, height: height))
        }

        if tagDisplay == .collapsed && numInFirstTwoRows > 0 {
            collapsedTags = Array(allTags.prefix(numInFirstTwoRows - 1))
        }
    }

    @objc private func tappedShowLess() {
        showLessButton.isHidden = true
        tagCollectionView.snp.updateConstraints { update in
            update.bottom.equalToSuperview().inset(10)
        }

        delegate?.changeListSummaryHeight(height: 145)
        tagDisplay = .collapsed
        tagCollectionView.reloadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ListSummaryCollectionViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch tagDisplay {
        case .collapsed:
            return collapsedTags.count
        case .expanded:
            return allTags.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if tagDisplay == .collapsed &&
            allTags.count > numInFirstTwoRows &&
            indexPath.item == numInFirstTwoRows - 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellReuseIdentifier, for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(for: "+ \(allTags.count - numInFirstTwoRows + 2) more", type: .more)
            return cell
        } else {
            let tag = tagDisplay == .collapsed ? collapsedTags[indexPath.item] : allTags[indexPath.item]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellReuseIdentifier, for: indexPath) as? TagCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(for: tag, type: .tag)
            // Uncomment when allow tag selection
//            // Select cell if it was previously selected
//            if let selectedIndexPath = selectedTagIndex, indexPath == selectedIndexPath {
//                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
//                cell.isSelected = true
//            }
            return cell
        }
    }

}

extension ListSummaryCollectionViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Uncomment when allow tag selection
//        if tagDisplay == .collapsed && indexPath.item != collapsedTags.count - 1 || tagDisplay == .expanded {
//            selectedTagIndex = indexPath
//        }

        // If tapped to show more tags
        if tagDisplay == .collapsed && indexPath.item == collapsedTags.count - 1 {
            tagDisplay = .expanded
            showLessButton.isHidden = false
            collectionView.snp.updateConstraints { update in
                update.bottom.equalToSuperview().inset(50)
            }
            collectionView.reloadData()

            let collectionViewHeight = tagRowCount * (Int(tagCellSpacing) + 25)
            delegate?.changeListSummaryHeight(height: collectionViewHeight + 120)
        }
    }

}

extension ListSummaryCollectionViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return allTagSizes[indexPath.item]
    }

}
