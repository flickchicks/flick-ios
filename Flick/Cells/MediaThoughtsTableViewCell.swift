//
//  MediaThoughtsTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/18/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import Kingfisher

class MediaThoughtsTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let commentCellView = UIView()
    private let commentDateLabel = UILabel()
    private let commentTextView = UITextView()
    private let commentLikeButton = UIButton()
    private let commentOwnerLabel = UILabel()
    private let commentProfileImageView = UIImageView()
//    private let noCommentLabel = UILabel()
    private let seeAllCommentsButton = UIButton()
    private let separatorView = UIView()
    private let titleLabel = UILabel()
    private let viewSpoilerButton = UIButton()

    // MARK: - Private Data Vars
    weak var delegate: CommentDelegate?
    private var comments: [Comment] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .movieWhite

        titleLabel.text = "Thoughts"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .darkBlue
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        contentView.addSubview(titleLabel)

        separatorView.backgroundColor = .lightGray2
        contentView.addSubview(separatorView)

        seeAllCommentsButton.contentHorizontalAlignment = .right
        seeAllCommentsButton.isHidden = true
        seeAllCommentsButton.addTarget(self, action: #selector(seeAllComments), for: .touchUpInside)
        seeAllCommentsButton.setTitleColor(.darkBlueGray2, for: .normal)
        seeAllCommentsButton.titleLabel?.font = .systemFont(ofSize: 12)
        contentView.addSubview(seeAllCommentsButton)

        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        commentProfileImageView.isUserInteractionEnabled = true
        commentProfileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        commentProfileImageView.layer.backgroundColor = UIColor.lightPurple.cgColor
        commentProfileImageView.contentMode = .scaleAspectFit
        commentProfileImageView.layer.cornerRadius = 20
        commentProfileImageView.layer.masksToBounds = true
        commentCellView.addSubview(commentProfileImageView)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(seeAllComments))
        commentTextView.isUserInteractionEnabled = true
        commentTextView.addGestureRecognizer(tapGestureRecognizer)
        commentTextView.isEditable = false
        commentTextView.isScrollEnabled = false
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        commentTextView.layer.backgroundColor = UIColor.lightGray2.cgColor
        commentTextView.font = .systemFont(ofSize: 12)
        commentTextView.textColor = .black
        commentTextView.layer.cornerRadius = 16
        commentCellView.addSubview(commentTextView)

        commentOwnerLabel.font = .systemFont(ofSize: 10)
        commentOwnerLabel.textColor = .mediumGray
        commentCellView.addSubview(commentOwnerLabel)

        commentDateLabel.font = .systemFont(ofSize: 10)
        commentDateLabel.textAlignment = .right
        commentDateLabel.textColor = .mediumGray
        commentCellView.addSubview(commentDateLabel)

        commentLikeButton.addTarget(self, action: #selector(likeComment), for: .touchUpInside)
        commentCellView.addSubview(commentLikeButton)

        viewSpoilerButton.setTitle("View", for: .normal)
        viewSpoilerButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        viewSpoilerButton.setTitleColor(.darkBlue, for: .normal)
        viewSpoilerButton.isHidden = true
        commentCellView.addSubview(viewSpoilerButton)

        commentCellView.sizeToFit()
        contentView.addSubview(commentCellView)

        setupConstraints()
    }

    private func setupConstraints() {
        let horizontalPadding: CGFloat = 20
        let heartImageSize = CGSize(width: 16, height: 14)
        let labelHeight: CGFloat = 12
        let profileImageSize = CGSize(width: 40, height: 40)
        let verticalPadding: CGFloat = 16
        let viewSpoilerButtonSize = CGSize(width: 34, height: 17)

        separatorView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(2)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(horizontalPadding)
            make.width.equalTo(83)
            make.top.equalTo(separatorView.snp.bottom).offset(17)
        }

        seeAllCommentsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalTo(titleLabel)
            make.height.equalTo(15)
            make.leading.equalTo(titleLabel.snp.trailing)
        }

        commentCellView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(verticalPadding)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalToSuperview()
        }

        commentProfileImageView.snp.makeConstraints { make in
            make.size.equalTo(profileImageSize)
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(verticalPadding)
        }

        commentOwnerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(labelHeight)
            make.leading.trailing.equalTo(commentTextView)
        }

        commentDateLabel.snp.makeConstraints { make in
            make.top.equalTo(commentOwnerLabel)
            make.height.equalTo(labelHeight)
            make.leading.equalTo(commentOwnerLabel.snp.trailing)
            make.trailing.equalToSuperview()
        }

        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(commentProfileImageView)
            make.trailing.equalToSuperview().inset(49)
            make.leading.equalTo(commentProfileImageView.snp.trailing).offset(8)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }

        commentLikeButton.snp.makeConstraints { make in
            make.size.equalTo(heartImageSize)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(commentTextView)
        }

        viewSpoilerButton.snp.makeConstraints { make in
            make.trailing.equalTo(commentTextView).inset(12)
            make.centerY.equalTo(commentTextView)
            make.size.equalTo(viewSpoilerButtonSize)
        }
    }

    @objc func seeAllComments() {
        delegate?.seeAllComments()
    }

    func configure(with media: Media) {
        guard let comments = media.comments else { return }
        self.comments = comments
        let numComments = comments.count
        seeAllCommentsButton.setTitle("See All \(numComments)", for: .normal)
        if numComments == 0 { return }
        let comment = comments[0]
//        commentTextView.text = comment.isSpoiler ? "This contains a spoiler" : comment.message
        commentTextView.text = comment.message
        viewSpoilerButton.isHidden = true
//        viewSpoilerButton.isHidden = !comment.isSpoiler
        commentOwnerLabel.text = comment.owner.name
        // TODO: Add logic to calculate difference between createdDate and currentDate
        commentDateLabel.text = Date().getDateLabelText(createdAt: comment.createdAt)
        // TODO: Add logic to discover if comment has been liked by user
        let heartImage = comment.hasLiked ? "filledHeart" : "heart"
        commentLikeButton.setImage(UIImage(named: heartImage), for: .normal)
        if let profilePic = comment.owner.profilePic {
            commentProfileImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePic, cacheKey: "userid-\(comment.owner.id)"))
        }
        seeAllCommentsButton.isHidden = false
    }

    @objc func likeComment() {
        if comments.count > 0 {
            delegate?.likeComment(index: 0)
        }
    }
    
    @objc func profileImageTapped() {
        if comments.count > 0 {
            delegate?.showProfile(userId: comments[0].owner.id)
        }
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        commentProfileImageView.image = nil
    }

}
