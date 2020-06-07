//
//  MediaListHeaderView.swift
//  Flick
//
//  Created by HAIYING WENG on 5/31/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaListHeaderView: UICollectionReusableView {
    
    // MARK: - Private View Vars
    private let addButton = UIButton()
    private let containerView = UIView()
    private let editButton = UIButton()
    private let roundView = RoundTopView(hasShadow: true)
    private let sortButton = UIButton()

    // MARK: - Private Data Vars
    private let buttonSize = CGSize(width: 44, height: 44)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .offWhite

        containerView.addSubview(roundView)
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        addButton.setImage(UIImage(named: "addButton"), for: .normal)
        addButton.layer.cornerRadius = buttonSize.width / 2
        addSubview(addButton)

        editButton.setImage(UIImage(named: "editButton"), for: .normal)
        editButton.layer.cornerRadius = buttonSize.width / 2
        addSubview(editButton)

        sortButton.setImage(UIImage(named: "sortButton"), for: .normal)
        sortButton.layer.cornerRadius = buttonSize.width / 2
        addSubview(sortButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundView.snp.top)
            make.trailing.equalTo(roundView.snp.trailing).inset(40)
            make.size.equalTo(buttonSize)
            
        }

        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundView.snp.top)
            make.trailing.equalTo(addButton.snp.leading).offset(-16)
            make.size.equalTo(buttonSize)
        }
        
        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundView.snp.top)
            make.trailing.equalTo(sortButton.snp.leading).offset(-16)
            make.size.equalTo(buttonSize)
        }
        
        roundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(buttonSize.height / 2)
            make.height.equalTo(90)
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}