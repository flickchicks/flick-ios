//
//  DiscoverFooterTableViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/13/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

class DiscoverFooterTableViewCell: UITableViewCell {

    private let feedbackButton = UIButton()
    private let label = UILabel()
    private let orLabel = UILabel()

    static let reuseIdentifier = "DiscoverFooterTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        label.text = "🎉 That’s all for now! 🎉"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkBlue
        contentView.addSubview(label)

        feedbackButton.setTitle("Send Feedback", for: .normal)
        feedbackButton.setTitleColor(.darkPurple, for: .normal)
        feedbackButton.addTarget(self, action: #selector(feedbackButtonPressed), for: .touchUpInside)
        feedbackButton.titleLabel?.font = .systemFont(ofSize: 12)
        contentView.addSubview(feedbackButton)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(15)
        }

        feedbackButton.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(9)
            make.bottom.equalToSuperview().inset(40)
        }
    }

    @objc func feedbackButtonPressed() {
        if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfU2Wn5uVFEuaWLmcBFZCm_UQiNRHKGKChgV8rgpLWFMtjp0Q/viewform") {
            UIApplication.shared.open(url)
        }
    }
    
}

