//
//  MediaSelectableCollectionViewCell.swift
//  Flick
//
//  Created by Haiying W on 6/29/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaSelectableCollectionViewCell: UICollectionViewCell {

    private let overlayView = UIView()
    private let posterImageView = UIImageView()
    private let selectView = UIView()

    private let selectSize = CGSize(width: 20, height: 20)

    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectView.layer.borderColor = UIColor.gradientPurple.cgColor
                layer.borderWidth = 2
                layer.borderColor = UIColor.gradientPurple.cgColor
                overlayView.isHidden = false
            } else {
                selectView.layer.borderColor = UIColor.lightGray.cgColor
                layer.borderWidth = 0
                overlayView.isHidden = true
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10

        posterImageView.backgroundColor = .lightGray2
        posterImageView.layer.cornerRadius = 10
        contentView.addSubview(posterImageView)

        overlayView.isHidden = true
        overlayView.backgroundColor = .purpleOverlay
        overlayView.layer.cornerRadius = 10
        contentView.addSubview(overlayView)

        selectView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        selectView.layer.cornerRadius = selectSize.width / 2
        selectView.layer.borderWidth = 2
        selectView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.addSubview(selectView)

        setupConstraints()
    }
    
    private func setupConstraints() {
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        selectView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
            make.size.equalTo(selectSize)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
