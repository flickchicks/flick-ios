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
    func sortMedia()
}

class MediaListHeaderView: UICollectionReusableView {
    
    // MARK: - Private View Vars
    private let addButton = UIButton()
    private let containerView = UIView()
    private let editButton = UIButton()
    private let roundTopView = RoundTopView(hasShadow: true)
    private let sortButton = UIButton()

    // MARK: - Private Data Vars
    private let buttonSize = CGSize(width: 44, height: 44)
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
        addSubview(addButton)

        editButton.addTarget(self, action: #selector(editMedia), for: .touchUpInside)
        editButton.layer.cornerRadius = buttonSize.width / 2
        addSubview(editButton)

        sortButton.addTarget(self, action: #selector(sortMedia), for: .touchUpInside)
        sortButton.layer.cornerRadius = buttonSize.width / 2
        addSubview(sortButton)

        setupConstraints()
    }

    func setupConstraints() {
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundTopView.snp.top)
            make.trailing.equalTo(roundTopView.snp.trailing).inset(40)
            make.size.equalTo(buttonSize)
            
        }

        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundTopView.snp.top)
            make.trailing.equalTo(addButton.snp.leading).offset(-16)
            make.size.equalTo(buttonSize)
        }

        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundTopView.snp.top)
            make.trailing.equalTo(sortButton.snp.leading).offset(-16)
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

    func configure(isEmptyList: Bool) {
        self.isEmptyList = isEmptyList
        editButton.setImage(UIImage(named: isEmptyList ? "editButtonInactive" : "editButton"), for: .normal)
        sortButton.setImage(UIImage(named: isEmptyList ? "sortButtonInactive" : "sortButton"), for: .normal)
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
