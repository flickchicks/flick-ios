//
//  ListTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 5/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SnapKit

class ListTableViewCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let seeAllButton = UIButton()
    private var mediaCollectionView: UICollectionView!

    private var media: [Media]!

    private let mediaCellReuseIdentifier = "MediaCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 14)
        contentView.addSubview(titleLabel)

        seeAllButton.setTitle("See All", for: .normal)
        seeAllButton.titleLabel?.font = .boldSystemFont(ofSize: 12)
//        seeAllButton.titleLabel?.textColor = .darkBlueGray
        seeAllButton.titleLabel?.textColor = .black
        contentView.addSubview(seeAllButton)

        let mediaLayout = UICollectionViewFlowLayout()
        mediaLayout.minimumInteritemSpacing = 12
        mediaLayout.scrollDirection = .horizontal

        mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mediaLayout)
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.isScrollEnabled = true
        mediaCollectionView.backgroundColor = .none
        mediaCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: mediaCellReuseIdentifier)
        contentView.addSubview(mediaCollectionView)

        setupConstraints()
    }

    private func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(34)
            make.height.equalTo(17)
        }

        seeAllButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(16)
//            make.bottom.equalTo(titleLabel)
//            make.height.equalTo(15)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(34)
            make.height.equalTo(17)
        }

        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview()
        }

    }


    func configure(for list: MediaList) {
        titleLabel.text = list.listName
        media = list.media
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension ListTableViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

}

extension ListTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifier, for: indexPath)
//        cell.backgroundView = UIImageView(image: UIImage(named: media[indexPath.item].posterPic))
        cell.backgroundColor = .lightPurple
        cell.layer.cornerRadius = 8
        return cell
    }
}

extension ListTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}
