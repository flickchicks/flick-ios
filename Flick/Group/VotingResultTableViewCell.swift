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
    private let numberLabel = UILabel()
    private let numVoteMaybeLabel = UILabel()
    private let numVoteNoLabel = UILabel()
    private let numVoteYesLabel = UILabel()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let voteMaybeImageView = UIImageView(image: UIImage(named: "voteMaybeEmoticon"))
    private let voteNoImageView = UIImageView(image: UIImage(named: "voteNoEmoticon"))
    private let voteYesImageView = UIImageView(image: UIImage(named: "voteYesEmoticon"))

    // MARK: - Data Vars
    static let reuseIdentifier = "VotingResultCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .offWhite

        numberLabel.textColor = .darkBlueGray2
        numberLabel.font = .systemFont(ofSize: 14, weight: .medium)
        numberLabel.backgroundColor = .lightGray2
        numberLabel.textAlignment = .center
        numberLabel.layer.cornerRadius = 12
        numberLabel.layer.masksToBounds = true
        contentView.addSubview(numberLabel)

        posterImageView.backgroundColor = .lightGray
        posterImageView.layer.cornerRadius = 4
        posterImageView.layer.masksToBounds = true
        contentView.addSubview(posterImageView)

        titleLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(titleLabel)

        contentView.addSubview(voteMaybeImageView)
        contentView.addSubview(voteNoImageView)
        contentView.addSubview(voteYesImageView)

        numVoteMaybeLabel.font = .systemFont(ofSize: 16)
        numVoteMaybeLabel.textColor = .mediumGray
        contentView.addSubview(numVoteMaybeLabel)

        numVoteNoLabel.font = .systemFont(ofSize: 16)
        numVoteNoLabel.textColor = .mediumGray
        contentView.addSubview(numVoteNoLabel)

        numVoteYesLabel.font = .systemFont(ofSize: 16)
        numVoteYesLabel.textColor = .mediumGray
        contentView.addSubview(numVoteYesLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let padding = 12
        let voteImageViewSize = CGSize(width: 19, height: 19)

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

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberLabel)
            make.leading.equalTo(posterImageView.snp.trailing).offset(padding)
        }

        voteYesImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.size.equalTo(voteImageViewSize)
        }

        numVoteYesLabel.snp.makeConstraints { make in
            make.top.equalTo(voteYesImageView)
            make.leading.equalTo(voteYesImageView.snp.trailing).offset(6)
        }

        voteMaybeImageView.snp.makeConstraints { make in
            make.top.equalTo(voteYesImageView)
            make.leading.equalTo(numVoteYesLabel.snp.trailing).offset(18)
            make.size.equalTo(voteImageViewSize)
        }

        numVoteMaybeLabel.snp.makeConstraints { make in
            make.top.equalTo(voteYesImageView)
            make.leading.equalTo(voteMaybeImageView.snp.trailing).offset(6)
        }

        voteNoImageView.snp.makeConstraints { make in
            make.top.equalTo(voteYesImageView)
            make.leading.equalTo(numVoteMaybeLabel.snp.trailing).offset(18)
            make.size.equalTo(voteImageViewSize)
        }

        numVoteNoLabel.snp.makeConstraints { make in
            make.top.equalTo(voteYesImageView)
            make.leading.equalTo(voteNoImageView.snp.trailing).offset(6)
        }
    }

    func configure(number: Int, result: MediaResult) {
        numberLabel.text = String(number)
        titleLabel.text = result.title
        numVoteNoLabel.text = String(result.numNoVotes)
        numVoteYesLabel.text = String(result.numYesVotes)
        numVoteMaybeLabel.text = String(result.numMaybeVotes)
        if let imageUrl = URL(string: result.posterPic ?? "") {
            posterImageView.kf.setImage(with: imageUrl)
        } else {
            posterImageView.image = UIImage(named: "defaultMovie")
        }
    }

}
