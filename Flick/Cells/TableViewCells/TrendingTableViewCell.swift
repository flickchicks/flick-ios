//
//  TrendingTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 12/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class TrendingTableViewCell: UITableViewCell {
    
    private var discoverCollectionView: UICollectionView!
    private var discoverShows: [DiscoverMedia] = []
    
    static var reuseIdentifier = "TrendingTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let discoverLayout = UICollectionViewFlowLayout()
        discoverLayout.scrollDirection = .horizontal
        discoverLayout.minimumInteritemSpacing = 20

        discoverCollectionView = UICollectionView(frame: .zero, collectionViewLayout: discoverLayout)
        discoverCollectionView.layer.backgroundColor = UIColor.yellow.cgColor
        discoverCollectionView.delegate = self
        discoverCollectionView.dataSource = self
        discoverCollectionView.contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 0)
        discoverCollectionView.register(DiscoverContentCell.self, forCellWithReuseIdentifier: DiscoverContentCell.reuseIdentifier)
        discoverCollectionView.showsHorizontalScrollIndicator = true
        discoverCollectionView.backgroundColor = UIColor.clear
//        discoverCollectionView.isScrollEnabled = true
        addSubview(discoverCollectionView)

        setupConstraints()
    }
    
    func setupConstraints() {
        discoverCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(500)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with shows: [DiscoverMedia]) {
        discoverShows = shows
        discoverCollectionView.reloadData()
    }
    
}

extension TrendingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discoverShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverContentCell.reuseIdentifier, for: indexPath) as? DiscoverContentCell else { return UICollectionViewCell()
        }
        let show = discoverShows[indexPath.row]
        cell.configure(with: show)
        return cell
    }
    
}

extension TrendingTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 312, height: 468)
    }

}

