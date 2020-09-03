//
//  ListPreviewView.swift
//  Flick
//
//  Created by Haiying W on 8/27/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class ListPreviewView: UIView {

    // MARK: - Private View Vars
    private let firstImageView = UIImageView()
    private let secondImageView = UIImageView()
    private let thirdImageView = UIImageView()

    // MARK: - Public Data Vars
    var firstThreeMedia: [SimpleMedia] = [] {
        didSet {
            setupMediaImages()
        }
    }
    init() {
        super.init(frame: .zero)

        thirdImageView.backgroundColor = .lightGray
        thirdImageView.layer.masksToBounds = true
        thirdImageView.layer.cornerRadius = 4
        addSubview(thirdImageView)

        secondImageView.backgroundColor = .lightGray
        secondImageView.layer.masksToBounds = true
        secondImageView.layer.cornerRadius = 4
        addSubview(secondImageView)

        firstImageView.backgroundColor = .lightGray
        firstImageView.layer.masksToBounds = true
        firstImageView.layer.cornerRadius = 4
        addSubview(firstImageView)

        setupConstraints()
    }

    private func setupConstraints() {
        let firstImageSize = CGSize(width: 32, height: 48)
        let secondImageSize = CGSize(width: 28, height: 42)
        let thirdImageSize = CGSize(width: 24, height: 36)

        firstImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(firstImageSize)
        }

        secondImageView.snp.makeConstraints { make in
            make.trailing.equalTo(firstImageView.snp.trailing).offset(3)
            make.centerY.equalToSuperview()
            make.size.equalTo(secondImageSize)
        }

        thirdImageView.snp.makeConstraints { make in
            make.trailing.equalTo(secondImageView.snp.trailing).offset(2)
            make.centerY.equalToSuperview()
            make.size.equalTo(thirdImageSize)
        }
    }

    private func setupMediaImages() {
        for i in 0..<firstThreeMedia.count {
            switch i {
            case 0:
                if let imageUrl = URL(string: firstThreeMedia[i].posterPic ?? "") {
                    firstImageView.kf.setImage(with: imageUrl)
                }
            case 1:
                if let imageUrl = URL(string: firstThreeMedia[i].posterPic ?? "") {
                    secondImageView.kf.setImage(with: imageUrl)
                }
            case 2:
                if let imageUrl = URL(string: firstThreeMedia[i].posterPic ?? "") {
                    thirdImageView.kf.setImage(with: imageUrl)
                }
            default:
                break
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
