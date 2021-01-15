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
    private let profileImageView = UIImageView()
    private let viewSpoilerButton = UIButton()

    // MARK: - Private Data Vars
    private var commentIndex: Int!
    weak var delegate: CommentDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .none

        profileImageView.layer.backgroundColor = UIColor.lightPurple.cgColor
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        addSubview(profileImageView)

        commentTextView.isEditable = false
        commentTextView.isScrollEnabled = false
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        commentTextView.layer.backgroundColor = UIColor.lightGray2.cgColor
        commentTextView.font = .systemFont(ofSize: 12)
        commentTextView.textColor = .black
        commentTextView.layer.cornerRadius = 16
        addSubview(commentTextView)

        nameLabel.font = .systemFont(ofSize: 10)
        nameLabel.textColor = .mediumGray
        addSubview(nameLabel)

        dateLabel.textAlignment = .right
        dateLabel.font = .systemFont(ofSize: 10)
        dateLabel.textColor = .mediumGray
        addSubview(dateLabel)

        likeButton.addTarget(self, action: #selector(likeComment), for: .touchUpInside)
        addSubview(likeButton)

        viewSpoilerButton.setTitle("View", for: .normal)
        viewSpoilerButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        viewSpoilerButton.setTitleColor(.darkBlue, for: .normal)
        viewSpoilerButton.isHidden = true
        addSubview(viewSpoilerButton)

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
            make.width.equalTo(horizontalPadding)
        }

        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-38)
            make.leading.equalTo(nameLabel)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }

        likeButton.snp.makeConstraints { make in
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

    /// Return the date label to be displayed given comment's created date
    private func getDateLabelText(createdAt: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let createdAtDate = dateFormatter.date(from: createdAt)
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from:  createdAtDate!, to: currentDate)
        // TODO: Complete logic to get date string
        return "1d"
    }

    func configure(for comment: Comment, index: Int, hideSpoiler: Bool, delegate: CommentDelegate) {
        self.commentIndex = index
        self.delegate = delegate
        commentTextView.text = comment.isSpoiler && hideSpoiler ? "This contains a spoiler" : comment.message
        nameLabel.text = comment.owner.name
        let dateLabelText = getDateLabelText(createdAt: comment.createdAt)
        dateLabel.text = dateLabelText
        // TODO: Complete logic to detect if comment has been liked
        let heartImage = "heart"
        likeButton.setImage(UIImage(named: heartImage), for: .normal)
        if let profilePic = comment.owner.profilePic {
            profileImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePic, cacheKey: "userid-\(comment.owner.id)"))
        }
        viewSpoilerButton.isHidden = !comment.isSpoiler || !hideSpoiler
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }

}
