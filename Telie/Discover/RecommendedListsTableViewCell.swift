//
//  RecommendedListsTableViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/7/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

class RecommendedListsTableViewCell: UITableViewCell {

    private var recommendedShowsCollectionView: UICollectionView!
    private let titleLabel = UILabel()
    private var lsts: [MediaList] = []

    weak var discoverDelegate: DiscoverDelegate?
    static var reuseIdentifier = "RecommendedListsTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .darkBlueGray2
        contentView.addSubview(titleLabel)

        let horizontalLayout = UICollectionViewFlowLayout()
        horizontalLayout.scrollDirection = .horizontal
        horizontalLayout.minimumInteritemSpacing = 16

        recommendedShowsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: horizontalLayout)
        recommendedShowsCollectionView.backgroundColor = .clear
        recommendedShowsCollectionView.delegate = self
        recommendedShowsCollectionView.dataSource = self
        recommendedShowsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        recommendedShowsCollectionView.register(RecommendedListsCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedListsCollectionViewCell.reuseIdentifier)
        recommendedShowsCollectionView.showsHorizontalScrollIndicator = false
        recommendedShowsCollectionView.isScrollEnabled = true
        recommendedShowsCollectionView.isSkeletonable = true
        contentView.addSubview(recommendedShowsCollectionView)

        setupConstraints()
    }

    func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(15)
        }

        recommendedShowsCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(536)
            make.bottom.equalToSuperview().inset(30)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with lsts: [MediaList], header: String) {
        titleLabel.text = header
        self.lsts = lsts
        recommendedShowsCollectionView.reloadData()
    }
}

extension RecommendedListsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lsts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedListsCollectionViewCell.reuseIdentifier, for: indexPath) as? RecommendedListsCollectionViewCell else { return UICollectionViewCell()
        }
        let list = lsts[indexPath.row]
        cell.configure(with: list)
        cell.discoverDelegate = discoverDelegate
        return cell
    }
}

extension RecommendedListsTableViewCell: UICollectionViewDelegate {

}

extension RecommendedListsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 340, height: 536)
    }
}
