//
//  CommentTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 7/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol CommentDelegate: class {
    func likeComment(index: Int)
    func addComment(commentText: String, isSpoiler: Bool)
    func showSpoilerModal(commentText: String)
    func seeAllComments()
}

// Creates UILabel with padding
class PaddedLabel: UILabel {

    let padding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let height = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }

}

class CommentTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let commentLabel = PaddedLabel()
    private let dateLabel = UILabel()
    private let likeButton = UIButton()
    private let nameLabel = UILabel()
    private let profileImageView = UIImageView()

    // MARK: - Private Data Vars
    private var commentIndex: Int!
    weak var delegate: CommentDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .none

        profileImageView.layer.backgroundColor = UIColor.lightPurple.cgColor
        profileImageView.layer.cornerRadius = 20
        addSubview(profileImageView)

        commentLabel.layer.backgroundColor = UIColor.lightGray2.cgColor
        commentLabel.font = .systemFont(ofSize: 12)
        commentLabel.textColor = .black
        commentLabel.numberOfLines = 0
        commentLabel.layer.cornerRadius = 16
        addSubview(commentLabel)

        nameLabel.font = .systemFont(ofSize: 10)
        nameLabel.textColor = .mediumGray
        addSubview(nameLabel)

        dateLabel.font = .systemFont(ofSize: 10)
        dateLabel.textColor = .mediumGray
        addSubview(dateLabel)

        likeButton.addTarget(self, action: #selector(likeComment), for: .touchUpInside)
        addSubview(likeButton)

        setupConstraints()
    }

    @objc func likeComment() {
        delegate?.likeComment(index: commentIndex)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

        let heartImageSize = CGSize(width: 16, height: 14)
        let labelHeight: CGFloat = 12
        let profileImageSize = CGSize(width: 40, height: 40)
        let horizontalPadding: CGFloat = 20
        let verticalPadding: CGFloat = 8

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
            make.trailing.equalToSuperview().inset(horizontalPadding)
            make.width.equalTo(20)
        }

        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-38)
            make.leading.equalTo(nameLabel)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }

        likeButton.snp.makeConstraints { make in
            make.size.equalTo(heartImageSize)
            make.trailing.equalToSuperview()
            make.centerY.equalTo(commentLabel)

        }

    }

    func configure(for comment: Comment, index: Int, delegate: CommentDelegate) {
        self.commentIndex = index
        self.delegate = delegate
        commentLabel.text = comment.message
        nameLabel.text = comment.owner.firstName
        dateLabel.text = "temp"
//        let heartImage = comment.liked ? "filledHeart" : "heart"
        let heartImage = "filledHeart"
        likeButton.setImage(UIImage(named: heartImage), for: .normal)
    }
}
