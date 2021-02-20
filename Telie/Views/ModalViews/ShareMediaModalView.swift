//
//  ShareMediaModalView.swift
//  Flick
//
//  Created by Haiying W on 12/29/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol ShareMediaDelegate: class {
    func showSuggestToFriendView()
    func shareToInstagramFeed()
}

class ShareMediaModalView: ModalView {

    // MARK: - Private View Vars
    private let cancelButton = UIButton()
    private let instagramButton = UIButton()
    private let instagramLabel = UILabel()
    private let instagramIconImageView = UIImageView()
    private let shareLabel = UILabel()
    private let suggestToFriendButton = UIButton()
    private let suggestToFriendLabel = UILabel()
    private let friendIconImageView = UIImageView()

    // MARK: - Private Data Vars
    weak var shareMediaDelegate: ShareMediaDelegate?

    override init() {
        super.init()

        shareLabel.text = "Share"
        shareLabel.font = .boldSystemFont(ofSize: 20)
        containerView.addSubview(shareLabel)

        suggestToFriendButton.layer.borderWidth = 1
        suggestToFriendButton.layer.cornerRadius = 8
        suggestToFriendButton.layer.borderColor = UIColor.darkBlue.withAlphaComponent(0.15).cgColor
        suggestToFriendButton.addTarget(self, action: #selector(suggestToFriendTapped), for: .touchUpInside)
        containerView.addSubview(suggestToFriendButton)
        
        friendIconImageView.image = UIImage(named: "friendIcon")
        suggestToFriendButton.addSubview(friendIconImageView)

        suggestToFriendLabel.text = "Suggest to friend"
        suggestToFriendLabel.textColor = .darkBlue
        suggestToFriendLabel.font = .systemFont(ofSize: 16)
        suggestToFriendButton.addSubview(suggestToFriendLabel)
        
        instagramButton.layer.borderWidth = 1
        instagramButton.layer.cornerRadius = 8
        instagramButton.layer.borderColor = UIColor.darkBlue.withAlphaComponent(0.15).cgColor
        instagramButton.addTarget(self, action: #selector(shareToInstagramTapped), for: .touchUpInside)
        containerView.addSubview(instagramButton)
        
        instagramLabel.text = "Instagram Story"
        instagramLabel.textColor = .darkBlue
        instagramLabel.font = .systemFont(ofSize: 16)
        instagramButton.addSubview(instagramLabel)
        
        instagramIconImageView.image = UIImage(named: "instagram")
        instagramButton.addSubview(instagramIconImageView)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.mediumGray, for: .normal)
        cancelButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        containerView.addSubview(cancelButton)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let containerViewSize = CGSize(width: 335, height: 259)
        let horizontalPadding = 24
        let verticalPadding = 36

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(containerViewSize)
        }

        shareLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalPadding)
            make.leading.equalToSuperview().offset(horizontalPadding)
        }
        
        friendIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(suggestToFriendButton)
            make.leading.equalToSuperview().offset(10.5)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }

        suggestToFriendButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(shareLabel.snp.bottom).offset(24)
            make.height.equalTo(44)
        }

        suggestToFriendLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(friendIconImageView.snp.trailing).offset(9.5)
        }
        
        instagramButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(suggestToFriendButton.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        
        instagramIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(instagramButton)
            make.leading.equalToSuperview().offset(10.5)
            make.size.equalTo(CGSize(width: 16, height: 16))
        }

        instagramLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(instagramIconImageView.snp.trailing).offset(9.5)
        }

        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(instagramButton.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func suggestToFriendTapped() {
        modalDelegate?.dismissModal(modalView: self)
        shareMediaDelegate?.showSuggestToFriendView()
    }

    @objc private func cancelTapped() {
        dismissModal()
    }
    
    @objc func shareToInstagramTapped() {
        shareMediaDelegate?.shareToInstagramFeed()
    }

}
