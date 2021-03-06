//
//  CommentTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 7/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import Kingfisher

protocol CommentDelegate: class {
    func likeComment(index: Int)
    func showProfile(userId: Int)
    func addComment(commentText: String, isSpoiler: Bool)
    func showSpoilerModal(commentText: String)
    func seeAllComments()
}

class CommentTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let commentTextView = UITextView()
    private let dateLabel = UILabel()
    private let likeButton = UIButton()
    private let nameLabel = UILabel()
    private let numLikeLabel = UILabel()
    private let profileImageView = UIImageView()
    private let viewSpoilerButton = UIButton()

    // MARK: - Private Data Vars
    private var comment: Comment!
    private var commentIndex: Int!
    weak var delegate: CommentDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear

        profileImageView.isUserInteractionEnabled = true
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.layer.backgroundColor = UIColor.lightPurple.cgColor
        profileImageView.layer.cornerRadius = 20
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        contentView.addSubview(profileImageView)

        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(likeComment))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        
        commentTextView.isEditable = false
        commentTextView.isScrollEnabled = false
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 6, bottom: 12, right: 6)
        commentTextView.layer.backgroundColor = UIColor.lightGray2.cgColor
        commentTextView.font = .systemFont(ofSize: 12)
        commentTextView.textColor = .black
        commentTextView.layer.cornerRadius = 16
        commentTextView.addGestureRecognizer(doubleTapGestureRecognizer)
        contentView.addSubview(commentTextView)

        nameLabel.font = .systemFont(ofSize: 10)
        nameLabel.textColor = .mediumGray
        contentView.addSubview(nameLabel)

        dateLabel.textAlignment = .right
        dateLabel.font = .systemFont(ofSize: 10)
        dateLabel.textColor = .mediumGray
        contentView.addSubview(dateLabel)

        likeButton.addTarget(self, action: #selector(likeComment), for: .touchUpInside)
        contentView.addSubview(likeButton)
        
        numLikeLabel.textAlignment = .center
        numLikeLabel.font = .systemFont(ofSize: 8)
        numLikeLabel.textColor = .mediumGray
        contentView.addSubview(numLikeLabel)

        viewSpoilerButton.setTitle("View", for: .normal)
        viewSpoilerButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        viewSpoilerButton.setTitleColor(.darkBlue, for: .normal)
        viewSpoilerButton.isHidden = true
        contentView.addSubview(viewSpoilerButton)

        setupConstraints()
    }

    @objc func likeComment() {
        delegate?.likeComment(index: commentIndex)
    }
    
    @objc func profileImageTapped() {
        delegate?.showProfile(userId: comment.owner.id)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let heartImageSize = CGSize(width: 16, height: 14)
        let horizontalPadding: CGFloat = 20
        let labelHeight: CGFloat = 12
        let profileImageSize = CGSize(width: 40, height: 40)
        let verticalPadding: CGFloat = 8
        let viewSpoilerButtonSize = CGSize(width: 34, height: 17)

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(profileImageSize)
            make.leading.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalPadding)
            make.height.equalTo(labelHeight)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(horizontalPadding)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.height.equalTo(labelHeight)
            make.trailing.equalTo(likeButton)
            make.width.equalTo(30)
        }

        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(nameLabel)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }

        likeButton.snp.makeConstraints { make in
            make.size.equalTo(heartImageSize)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(commentTextView)
        }
        
        numLikeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(likeButton)
            make.size.equalTo(CGSize(width: 25, height: 9))
            make.top.equalTo(likeButton.snp.bottom).offset(2)
        }

        viewSpoilerButton.snp.makeConstraints { make in
            make.trailing.equalTo(commentTextView).inset(12)
            make.centerY.equalTo(commentTextView)
            make.size.equalTo(viewSpoilerButtonSize)
        }
    }

    func configure(for comment: Comment, index: Int, hideSpoiler: Bool, delegate: CommentDelegate) {
        self.comment = comment
        self.commentIndex = index
        self.delegate = delegate
//        commentTextView.text = comment.isSpoiler && hideSpoiler ? "This contains a spoiler" : comment.message
        commentTextView.text = comment.message
        nameLabel.text = comment.owner.name
        if comment.message.count > 46 {
            commentTextView.snp.remakeConstraints { remake in
                remake.top.equalTo(profileImageView)
                remake.trailing.equalTo(dateLabel.snp.leading).offset(-38)
                remake.leading.equalTo(nameLabel)
                remake.bottom.equalToSuperview().inset(8)
            }
        }
        let dateLabelText = Date().getDateLabelText(createdAt: comment.createdAt)
        dateLabel.text = dateLabelText
        let heartImage = comment.hasLiked ? "filledHeart" : "heart"
        likeButton.setImage(UIImage(named: heartImage), for: .normal)
        if let profilePic = comment.owner.profilePic {
            profileImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePic, cacheKey: "userid-\(comment.owner.id)"))
        }
        viewSpoilerButton.isHidden = true
        numLikeLabel.text = comment.numLikes > 0 ? "\(comment.numLikes)" : ""
//        viewSpoilerButton.isHidden = !comment.isSpoiler || !hideSpoiler
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        likeButton.imageView?.image = nil
        commentTextView.snp.remakeConstraints { remake in
            remake.top.equalTo(profileImageView)
            remake.leading.equalTo(nameLabel)
            remake.bottom.equalToSuperview().inset(8)
        }
    }

}
