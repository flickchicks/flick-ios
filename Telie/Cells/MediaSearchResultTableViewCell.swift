//
//  MediaSearchResultTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 6/29/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaSearchResultTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let checkImageView = UIImageView()
    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let posterImageView = UIImageView()
    private let selectView = SelectIndicatorView(width: 20)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        containerView.layer.cornerRadius = 6
        contentView.addSubview(containerView)

        posterImageView.backgroundColor = .lightGray
        posterImageView.layer.cornerRadius = 4
        posterImageView.layer.masksToBounds = true
        containerView.addSubview(posterImageView)

        nameLabel.textColor = .darkBlue
        nameLabel.font = .systemFont(ofSize: 16)
        containerView.addSubview(nameLabel)

        containerView.addSubview(selectView)

        setupConstraints()
    }

    private func setupConstraints() {
        let posterSize = CGSize(width: 36, height: 54)
        let selectSize = CGSize(width: 20, height: 20)

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.leading.trailing.equalToSuperview()
        }

        posterImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.size.equalTo(posterSize)
        }

        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalTo(selectView.snp.leading).offset(-10)
        }

        selectView.snp.makeConstraints { make in
            make.size.equalTo(selectSize)
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }

    func configure(media: Media) {
        nameLabel.text = media.title
        if let imageUrl = URL(string: media.posterPic ?? "") {
            posterImageView.kf.setImage(with: imageUrl)
        } else {
            posterImageView.image = UIImage(named: "defaultMovie")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            containerView.backgroundColor = .lightGray2
            selectView.select()
        } else {
            containerView.backgroundColor = .white
            selectView.deselect()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }

}
