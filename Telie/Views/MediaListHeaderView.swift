//
//  MediaListHeaderView.swift
//  Flick
//
//  Created by HAIYING WENG on 5/31/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol MediaListHeaderDelegate: class {
    func addMedia()
    func editMedia()
    func likeList()
    func sortMedia()
}

class MediaListHeaderView: UICollectionReusableView {
    
    // MARK: - Private View Vars
    private let addButton = UIButton()
    private let containerView = UIView()
    private let editButton = UIButton()
    private let likeButton = UIButton()
    private let roundTopView = RoundTopView(hasShadow: true)
//    private let sortButton = UIButton()

    // MARK: - Private Data Vars
    private let buttonSize = CGSize(width: 44, height: 44)
    private var hasLiked = false
    var isEmptyList = true

    weak var delegate: MediaListHeaderDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .offWhite

        containerView.addSubview(roundTopView)
        containerView.clipsToBounds = true
        addSubview(containerView)

        addButton.setImage(UIImage(named: "addButton"), for: .normal)
        addButton.addTarget(self, action: #selector(addMedia), for: .touchUpInside)
        addButton.layer.cornerRadius = buttonSize.width / 2
        addButton.isHidden = true
        addSubview(addButton)

        editButton.addTarget(self, action: #selector(editMedia), for: .touchUpInside)
        editButton.layer.cornerRadius = buttonSize.width / 2
        editButton.isHidden = true
        addSubview(editButton)

        likeButton.addTarget(self, action: #selector(likeList), for: .touchUpInside)
        likeButton.layer.cornerRadius = buttonSize.width / 2
        likeButton.isHidden = true
        addSubview(likeButton)

//        sortButton.addTarget(self, action: #selector(sortMedia), for: .touchUpInside)
//        sortButton.layer.cornerRadius = buttonSize.width / 2
//        addSubview(sortButton)

        setupConstraints()
    }

    func setupConstraints() {
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundTopView.snp.top)
            make.trailing.equalTo(roundTopView.snp.trailing).inset(40)
            make.size.equalTo(buttonSize)
        }

        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundTopView.snp.top)
            make.trailing.equalTo(roundTopView.snp.trailing).inset(40)
            make.size.equalTo(buttonSize)
        }

//        sortButton.snp.makeConstraints { make in
//            make.centerY.equalTo(roundTopView.snp.top)
//            make.trailing.equalTo(addButton.snp.leading).offset(-16)
//            make.size.equalTo(buttonSize)
//        }

        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundTopView.snp.top)
            make.trailing.equalTo(addButton.snp.leading).offset(-16)
            make.size.equalTo(buttonSize)
        }

        roundTopView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(buttonSize.height / 2)
            make.height.equalTo(90)
            make.leading.trailing.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    func configure(for list: MediaList?, canModifyMedia: Bool) {
        guard let list = list else { return }
        self.hasLiked = list.hasLiked
        self.isEmptyList = list.shows.count == 0
        editButton.setImage(UIImage(named: isEmptyList ? "editButtonInactive" : "editButton"), for: .normal)
        likeButton.setImage(UIImage(named: hasLiked ? "likedButton" : "likeButton"), for: .normal)
//        sortButton.setImage(UIImage(named: isEmptyList ? "sortButtonInactive" : "sortButton"), for: .normal)
        addButton.isHidden = !canModifyMedia
        editButton.isHidden = !canModifyMedia
        likeButton.isHidden = canModifyMedia
    }

    @objc func addMedia() {
        delegate?.addMedia()
    }

    @objc func editMedia() {
        if !isEmptyList {
            delegate?.editMedia()
        }
    }

    @objc func sortMedia() {
        if !isEmptyList {
            delegate?.sortMedia()
        }
    }

    @objc func likeList() {
        likeButton.setImage(UIImage(named: hasLiked ? "likeButton" : "likedButton"), for: .normal)
        delegate?.likeList()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
