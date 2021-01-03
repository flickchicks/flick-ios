//
//  TrendingContentCollectionViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 12/24/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SkeletonView

class TrendingContentCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private View Variables
    private let imageView = UIImageView()
    private let saveButton = UIButton()
    private let shareButton = UIButton()
    private var mediaId: Int!
    weak var delegate: MediaControllerDelegate?
    
    static let reuseIdentifier = "TrendingContentCellReuseIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        isSkeletonable = true
        
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isSkeletonable = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        shareButton.setImage(UIImage(named: "shareButton"), for: .normal)
        contentView.addSubview(shareButton)
        
        saveButton.setImage(UIImage(named: "saveButton"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveMedia), for: .touchUpInside)
        contentView.addSubview(saveButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.trailing.equalTo(imageView).inset(12)
            make.centerY.equalTo(imageView.snp.bottom)
        }
        
        shareButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.trailing.equalTo(saveButton.snp.leading).offset(-6)
            make.centerY.equalTo(saveButton)
        }
        
    }
    
    @objc func saveMedia() {
        NetworkManager.addToMediaList(listId: 1, mediaIds: [mediaId]) { [weak self] list in
            guard let self = self else { return }
            self.delegate?.persentInfoAlert(message: "Saved")
        }
    }
    
    func configure(with media: SimpleMedia) {
        mediaId = media.id
        if let posterPic = media.posterPic, let imageUrl = URL(string: posterPic) {
            imageView.kf.setImage(with: imageUrl)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
