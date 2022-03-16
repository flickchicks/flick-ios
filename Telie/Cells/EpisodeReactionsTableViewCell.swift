//
//  EpisodeReactionsTableViewCell.swift
//  Telie
//
//  Created by Haiying W on 3/15/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class EpisodeReactionsTableViewCell: UITableViewCell {

    private let episodeNameLabel = UILabel()
    private var reactionsCollectionView: UICollectionView!

    static let reuseIdentifier = "EpisodeReactionsReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .offWhite

        episodeNameLabel.text = "Episode 1"
        episodeNameLabel.textColor = .darkBlue
        episodeNameLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(episodeNameLabel)

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .horizontal

        reactionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        reactionsCollectionView.register(ReactionCollectionViewCell.self, forCellWithReuseIdentifier: ReactionCollectionViewCell.cellReuseIdentitifer)
        reactionsCollectionView.delegate = self
        reactionsCollectionView.dataSource = self
        reactionsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        reactionsCollectionView.backgroundColor = .clear
        reactionsCollectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(reactionsCollectionView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        episodeNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        reactionsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(episodeNameLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    func configure(episodeNum: Int) {
        episodeNameLabel.text = "Episode \(episodeNum)"
    }

}

extension EpisodeReactionsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReactionCollectionViewCell.cellReuseIdentitifer, for: indexPath) as? ReactionCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 125)
    }

}
