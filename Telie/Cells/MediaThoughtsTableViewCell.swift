//
//  MediaThoughtsTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/18/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Kingfisher
import NVActivityIndicatorView
import UIKit

class MediaThoughtsTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let commentCellView = UIView()
    private let commentDateLabel = UILabel()
    private let commentTextView = UITextView()
    private let commentLikeButton = UIButton()
    private let commentLikeContainerView = UIView()
    private let commentNumLikeLabel = UILabel()
    private let commentOwnerLabel = UILabel()
    private let commentProfileImageView = UIImageView()
//    private let noCommentLabel = UILabel()
    private let seeAllCommentsButton = UIButton()
    private let separatorView = UIView()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 15, height: 15),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
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
        commentProfileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        commentProfileImageView.contentMode = .scaleAspectFit
        commentProfileImageView.layer.cornerRadius = 20
        commentProfileImageView.layer.masksToBounds = true
        commentProfileImageView.clipsToBounds = true
        commentProfileImageView.contentMode = .scaleAspectFill
        commentCellView.addSubview(commentProfileImageView)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(seeAllComments))
        
        commentTextView.isUserInteractionEnabled = true
        commentTextView.addGestureRecognizer(tapGestureRecognizer)
        commentTextView.isEditable = false
        commentTextView.isScrollEnabled = false
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6)
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

        commentCellView.addSubview(commentLikeContainerView)

        let likeTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeComment))
        commentLikeContainerView.addGestureRecognizer(likeTapGestureRecognizer)

        commentLikeContainerView.addSubview(spinner)

        commentLikeButton.addTarget(self, action: #selector(likeComment), for: .touchUpInside)
        commentLikeContainerView.addSubview(commentLikeButton)
        
        commentNumLikeLabel.textAlignment = .center
        commentNumLikeLabel.font = .systemFont(ofSize: 8)
        commentNumLikeLabel.textColor = .mediumGray
        commentLikeContainerView.addSubview(commentNumLikeLabel)

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
            make.leading.equalTo(commentProfileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(horizontalPadding)
        }

        commentDateLabel.snp.makeConstraints { make in
            make.top.equalTo(commentOwnerLabel)
            make.height.equalTo(labelHeight)
            make.leading.equalTo(commentOwnerLabel.snp.trailing)
            make.trailing.equalToSuperview()
        }

        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(commentProfileImageView)
            make.leading.equalTo(commentProfileImageView.snp.trailing).offset(8)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }

        commentLikeContainerView.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.centerY.height.equalTo(commentTextView)
            make.trailing.equalToSuperview().offset(10)
        }

        commentLikeButton.snp.makeConstraints { make in
            make.size.equalTo(heartImageSize)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        commentNumLikeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(commentLikeButton)
            make.size.equalTo(CGSize(width: 25, height: 9))
            make.top.equalTo(commentLikeButton.snp.bottom).offset(2)
        }

        viewSpoilerButton.snp.makeConstraints { make in
            make.trailing.equalTo(commentTextView).inset(12)
            make.centerY.equalTo(commentTextView)
            make.size.equalTo(viewSpoilerButtonSize)
        }

        spinner.snp.makeConstraints { make in
            make.center.equalTo(commentLikeButton)
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
        if numComments == 0 {
            commentTextView.attributedText = NSAttributedString(
                string: "No thoughts yet. Leave a comment!",
                attributes: [.font : UIFont.italicSystemFont(ofSize: 12)])
            commentTextView.textColor = .darkGray
            setCommentViewFullWidth()
            return
        }
        commentTextView.textColor = .black
        commentTextView.font = .systemFont(ofSize: 12)
        let comment = comments[comments.count-1]
        commentTextView.text = comment.message
        // TODO: Fix comment cell resize logic here
        if comment.message.count > 46 || comment.message.count == 0 {
            setCommentViewFullWidth()
        }
        viewSpoilerButton.isHidden = true
        commentOwnerLabel.text = comment.owner.name
        // TODO: Add logic to calculate difference between createdDate and currentDate
        commentDateLabel.text = Date().getDateLabelText(createdAt: comment.createdAt)
        let heartImage = comment.hasLiked ?? false ? "filledHeart" : "heart"
        commentLikeButton.setImage(UIImage(named: heartImage), for: .normal)
        if let imageUrl = URL(string: comment.owner.profilePicUrl ?? "") {
            commentProfileImageView.kf.setImage(with: imageUrl)
        } else {
            commentProfileImageView.kf.setImage(with: URL(string: Constants.User.defaultImage))
        }
        commentNumLikeLabel.text = comment.numLikes > 0 ? "\(comment.numLikes)" : ""
        seeAllCommentsButton.isHidden = false
    }

    @objc func likeComment() {
        if comments.count > 0 {
            spinner.startAnimating()
            commentLikeButton.isHidden = true
            delegate?.likeComment(index: comments.count-1)
        }
    }
    
    @objc func profileImageTapped() {
        if comments.count > 0 {
            delegate?.showProfile(userId: comments[comments.count-1].owner.id)
        }
    }

    private func setCommentViewFullWidth() {
        commentTextView.snp.remakeConstraints { remake in
            remake.top.equalTo(commentProfileImageView)
            remake.trailing.equalTo(commentDateLabel.snp.leading).offset(-38)
            remake.leading.equalTo(commentOwnerLabel)
            remake.bottom.equalToSuperview().inset(8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        spinner.stopAnimating()
        commentProfileImageView.image = nil
        commentLikeButton.imageView?.image = nil
        commentLikeButton.isHidden = false
        commentTextView.snp.remakeConstraints { remake in
            remake.top.equalTo(commentProfileImageView)
            remake.leading.equalTo(commentOwnerLabel)
            remake.bottom.equalToSuperview().inset(8)
        }
    }

}
