//
//  TrendingTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 12/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol MediaControllerDelegate: class {
    func showMediaViewController(id: Int)
    func presentInfoAlert(message: String)
}

class TrendingTableViewCell: UITableViewCell {
    
    private var discoverCollectionView: UICollectionView!
    private var discoverShows: [SimpleMedia] = []
    
    weak var delegate: MediaControllerDelegate?
    static var reuseIdentifier = "TrendingTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
                
        let discoverLayout = UICollectionViewFlowLayout()
        discoverLayout.scrollDirection = .horizontal
        discoverLayout.minimumInteritemSpacing = 20
        discoverLayout.minimumLineSpacing = 11

        discoverCollectionView = UICollectionView(frame: .zero, collectionViewLayout: discoverLayout)
        discoverCollectionView.backgroundColor = .clear
        discoverCollectionView.delegate = self
        discoverCollectionView.dataSource = self
        discoverCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        discoverCollectionView.register(TrendingContentCollectionViewCell.self, forCellWithReuseIdentifier: TrendingContentCollectionViewCell.reuseIdentifier)
        discoverCollectionView.showsHorizontalScrollIndicator = false
        discoverCollectionView.isScrollEnabled = true
        contentView.addSubview(discoverCollectionView)

        setupConstraints()
    }
    
    func setupConstraints() {
        discoverCollectionView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with shows: [SimpleMedia]) {
        discoverShows = shows
        discoverCollectionView.reloadData()
    }
    
}

extension TrendingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return discoverShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingContentCollectionViewCell.reuseIdentifier, for: indexPath) as? TrendingContentCollectionViewCell else { return UICollectionViewCell()
        }
        let show = discoverShows[indexPath.row]
        cell.configure(with: show)
        cell.delegate = delegate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = discoverShows[indexPath.item]
        delegate?.showMediaViewController(id: show.id)
    }
    
}

extension TrendingTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 312, height: 468)
    }

}

