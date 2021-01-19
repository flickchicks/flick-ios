//
//  ShareMediaModalView.swift
//  Flick
//
//  Created by Haiying W on 12/29/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol ShareMediaDelegate: class {
    func showFlickToFriendView()
}

class ShareMediaModalView: ModalView {

    // MARK: - Private View Vars
    private let cancelButton = UIButton()
    private let flickToFriendButton = UIButton()
    private let flickToFriendLabel = UILabel()
    private let rightChevronImageView = UIImageView()
    private let shareLabel = UILabel()

    // MARK: - Private Data Vars
    weak var shareMediaDelegate: ShareMediaDelegate?

    override init() {
        super.init()

        shareLabel.text = "Share"
        shareLabel.font = .boldSystemFont(ofSize: 20)
        containerView.addSubview(shareLabel)

        flickToFriendButton.addTarget(self, action: #selector(flickToFriendTapped), for: .touchUpInside)
        containerView.addSubview(flickToFriendButton)

        flickToFriendLabel.text = "Flick to a friend"
        flickToFriendLabel.textColor = .darkBlue
        flickToFriendLabel.font = .systemFont(ofSize: 16)
        flickToFriendButton.addSubview(flickToFriendLabel)

        rightChevronImageView.image = UIImage(named: "rightChevron")
        rightChevronImageView.isUserInteractionEnabled = false
        flickToFriendButton.addSubview(rightChevronImageView)

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
        let containerViewSize = CGSize(width: 335, height: 210)
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

        flickToFriendButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(shareLabel.snp.bottom).offset(verticalPadding)
            make.height.equalTo(20)
        }

        flickToFriendLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        rightChevronImageView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(5)
            make.height.equalTo(10)
        }

        cancelButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(verticalPadding)
            make.centerX.equalToSuperview()
        }
    }

    @objc private func flickToFriendTapped() {
        modalDelegate?.dismissModal(modalView: self)
        shareMediaDelegate?.showFlickToFriendView()
    }

    @objc private func cancelTapped() {
        dismissModal()
    }

}
