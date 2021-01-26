//
//  VotingResultTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 1/25/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class VotingResultTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let nameLabel = UILabel()
    private let numberLabel = UILabel()
    private let posterImageView = UIImageView()
    private let voteYesLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .offWhite

        numberLabel.textColor = .darkBlueGray2
        numberLabel.font = .systemFont(ofSize: 14)
        numberLabel.backgroundColor = .lightGray2
        numberLabel.textAlignment = .center
        numberLabel.layer.cornerRadius = 12
        numberLabel.layer.masksToBounds = true
        contentView.addSubview(numberLabel)

        posterImageView.backgroundColor = .lightGray
        posterImageView.layer.cornerRadius = 4
        contentView.addSubview(posterImageView)

        nameLabel.text = "Wonder Women"
        nameLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(nameLabel)

        voteYesLabel.text = "6/7 said yes"
        voteYesLabel.font = .systemFont(ofSize: 16)
        voteYesLabel.textColor = .mediumGray
        contentView.addSubview(voteYesLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let padding = 12

        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.leading.equalToSuperview().offset(24)
            make.height.width.equalTo(24)
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel)
            make.bottom.equalToSuperview().inset(padding)
            make.leading.equalTo(numberLabel.snp.trailing).offset(padding)
            make.size.equalTo(CGSize(width: 50, height: 75))
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel)
            make.leading.equalTo(posterImageView.snp.trailing).offset(padding)
        }

        voteYesLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nameLabel)
        }
    }

    func configure(number: Int) {
        numberLabel.text = String(number)
    }

}
