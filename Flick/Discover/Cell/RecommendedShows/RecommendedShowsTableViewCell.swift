//
//  RecommendedShowsTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 2/19/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class RecommendedShowsTableViewCell: UITableViewCell {
    
    private var recommendedShowsCollectionView: UICollectionView!
    private let titleLabel = UILabel()
    private var shows: [SimpleMedia] = []
    
    weak var delegate: MediaControllerDelegate?
    static var reuseIdentifier = "RecommendedShowsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        titleLabel.text = "📺 Shows For You"
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .darkBlueGray2
        contentView.addSubview(titleLabel)
        
        let discoverLayout = UICollectionViewFlowLayout()
        discoverLayout.scrollDirection = .horizontal
        discoverLayout.minimumInteritemSpacing = 16

        recommendedShowsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: discoverLayout)
        recommendedShowsCollectionView.backgroundColor = .clear
        recommendedShowsCollectionView.delegate = self
        recommendedShowsCollectionView.dataSource = self
        recommendedShowsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        recommendedShowsCollectionView.register(RecommendedShowsCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedShowsCollectionViewCell.reuseIdentifier)
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
            make.height.equalTo(500)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with shows: [SimpleMedia]) {
        self.shows = shows
        recommendedShowsCollectionView.reloadData()
    }
}

extension RecommendedShowsTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedShowsCollectionViewCell.reuseIdentifier, for: indexPath) as? RecommendedShowsCollectionViewCell else { return UICollectionViewCell()
        }
        let show = shows[indexPath.row]
        cell.configure(with: show)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = shows[indexPath.item]
        delegate?.showMediaViewController(id: show.id, mediaImageUrl: show.posterPic)
    }
}

extension RecommendedShowsTableViewCell: UICollectionViewDelegate {
    
}

extension RecommendedShowsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 312, height: 500)
    }
}

