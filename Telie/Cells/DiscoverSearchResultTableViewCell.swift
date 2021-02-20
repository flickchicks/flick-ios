//
//  DiscoverSearchResultTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 8/26/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import Kingfisher
import SkeletonView

class DiscoverSearchResultTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let iconImageView = UIImageView()
    private let infoStackView = UIStackView()
    private let listPreviewView = ListPreviewView()
    private let resultImageView =  UIImageView()
    private let subtitleLabel = UILabel()
    private let subtitleStackView = UIStackView()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let circleImageViewSize = CGSize(width: 44, height: 44)
    private let listPreviewSize = CGSize(width: 49, height: 66)
    private let posterImageViewSize = CGSize(width: 44, height: 66)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .offWhite
        selectionStyle = .none
        isSkeletonable = true

        infoStackView.axis = .vertical
        infoStackView.spacing = 5
        contentView.addSubview(infoStackView)

        titleLabel.isSkeletonable = true
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        infoStackView.addArrangedSubview(titleLabel)

        subtitleStackView.axis = .horizontal
        subtitleStackView.spacing = 5
        infoStackView.addArrangedSubview(subtitleStackView)

        let iconSize = CGSize(width: 14, height: 14)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
        }
        subtitleStackView.addArrangedSubview(iconImageView)

        subtitleLabel.textColor = .mediumGray
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleStackView.addArrangedSubview(subtitleLabel)

        resultImageView.backgroundColor = .lightGray
        resultImageView.layer.masksToBounds = true
        resultImageView.layer.cornerRadius = 4
        resultImageView.contentMode = .scaleAspectFill
        contentView.addSubview(resultImageView)

        listPreviewView.isHidden = true
        contentView.addSubview(listPreviewView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureList(list: MediaList) {
        titleLabel.text = list.name
        subtitleStackView.isHidden = false
        resultImageView.isHidden = true
        iconImageView.isHidden = true
        listPreviewView.isHidden = false
        listPreviewView.firstThreeMedia = Array(list.shows.prefix(3))
        setupConstraintsForListPreview()
        subtitleLabel.text = "by \(list.owner.name)"
    }

    func configureMovie(movie: Media) {
        titleLabel.text = movie.title
        if let dateReleased = movie.dateReleased {
            subtitleLabel.text = String(dateReleased.prefix(4))
        }
        subtitleStackView.isHidden = false
        resultImageView.layer.cornerRadius = 4
        resultImageView.isHidden = false
        updateConstraintsForPoster()
        iconImageView.isHidden = false
        iconImageView.image = UIImage(named: "film")
        listPreviewView.isHidden = true
        if let imageUrl = URL(string: movie.posterPic ?? "") {
            resultImageView.kf.setImage(with: imageUrl)
        } else {
            resultImageView.image = UIImage(named: "defaultMovie")
        }
    }

    func configureUser(isCurrentUser: Bool, user: UserProfile) {
        titleLabel.text = user.name
        updateConstraintsForCircleImage()
        iconImageView.isHidden = true
        subtitleLabel.isHidden = isCurrentUser
        subtitleLabel.text = "@\(user.username) • \(user.numMutualFriends ?? 0) mutual friends"
        resultImageView.layer.cornerRadius = circleImageViewSize.width / 2
        resultImageView.isHidden = false
        listPreviewView.isHidden = true
        if let profilePic = user.profilePic {
            resultImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePic, cacheKey: "userid-\(user.id)"))
        } else {
            resultImageView.image = nil
        }
    }

    func configureShow(show: Media) {
        titleLabel.text = show.title
        subtitleStackView.isHidden = false
        if let dateReleased = show.dateReleased {
            subtitleLabel.text = String(dateReleased.prefix(4))
        }
        resultImageView.layer.cornerRadius = 4
        resultImageView.isHidden = false
        updateConstraintsForPoster()
        iconImageView.isHidden = false
        iconImageView.image = UIImage(named: "tv")
        listPreviewView.isHidden = true
        if let imageUrl = URL(string: show.posterPic ?? "") {
            resultImageView.kf.setImage(with: imageUrl)
        } else {
            resultImageView.image = UIImage(named: "defaultMovie")
        }
    }

    func configureTag(tag: Tag) {
        titleLabel.text = tag.name
        updateConstraintsForCircleImage()
        resultImageView.layer.cornerRadius = circleImageViewSize.width / 2
        resultImageView.image = UIImage(named: "tag")
        resultImageView.isHidden = false
        subtitleStackView.isHidden = true
        listPreviewView.isHidden = true
    }

    private func setupConstraints() {
        resultImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(posterImageViewSize)
            make.top.bottom.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }

        infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(resultImageView.snp.trailing).offset(10)
            make.trailing.centerY.equalToSuperview()
        }
    }

    private func updateConstraintsForPoster() {
        resultImageView.snp.updateConstraints { update in
            update.size.equalTo(posterImageViewSize)
        }
    }

    private func updateConstraintsForCircleImage() {
        resultImageView.snp.updateConstraints { update in
            update.size.equalTo(circleImageViewSize)
        }
    }

    private func setupConstraintsForListPreview() {
        listPreviewView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(listPreviewSize)
            make.top.bottom.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }

        infoStackView.snp.makeConstraints { remake in
            remake.leading.equalTo(listPreviewView.snp.trailing).offset(10)
            remake.trailing.equalToSuperview()
            remake.centerY.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resultImageView.image = nil
    }

}