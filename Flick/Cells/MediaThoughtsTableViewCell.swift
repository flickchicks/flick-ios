//
//  MediaThoughtsTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 8/18/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class MediaThoughtsTableViewCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let separatorView = UIView()
    private let seeAllCommentsButton = UIButton()
    private let commentTableViewCell = CommentTableViewCell()
    private let commentsTableView = UITableView(frame: .zero, style: .plain)
    weak var delegate: CommentDelegate?
    private var comments: [Comment] = [Comment(createdAt: "2020-08-08T02:47:53.060628Z", id: "", isSpoiler: false, numLikes: 2, likers: [], owner: CommentUser(userId: "", username: "sdf", firstName: "dsf", lastName: "fsdf", profileId: "fsdf", profilePic: nil), message: "sdfaksfdlsadfklsahdfklsahdfklshdaflkhasdlkjfahksljdfhklasjfhkladsjfhkljsdfhklasdjfalsjdfhklsajdfhklasdhfkalsjdfhklasdjfhklasdjfhklasdjfhklsadjfhklsadjfhkalsdjfhklasddjfhklasdjfhklasdsahdfklsafsdfa")]


    private let commentLabel = PaddedLabel()
    private let dateLabel = UILabel()
    private let likeButton = UIButton()
    private let nameLabel = UILabel()
    private let profileImageView = UIImageView()


    private let commentsCellReuseIdentifier = "CommentsTableCellReuseIdentifier"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .movieWhite
        // Initialization code
        titleLabel.text = "Thoughts"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .darkBlue
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        addSubview(titleLabel)

        separatorView.backgroundColor = .lightGray2
        addSubview(separatorView)

        seeAllCommentsButton.contentHorizontalAlignment = .right
        seeAllCommentsButton.isHidden = true
        seeAllCommentsButton.addTarget(self, action: #selector(seeAllComments), for: .touchUpInside)
        seeAllCommentsButton.setTitleColor(.darkBlueGray2, for: .normal)
        seeAllCommentsButton.titleLabel?.font = .systemFont(ofSize: 12)
        addSubview(seeAllCommentsButton)

        profileImageView.layer.backgroundColor = UIColor.lightPurple.cgColor
        profileImageView.layer.cornerRadius = 20
        profileImageView.isHidden = true
        addSubview(profileImageView)

//        commentLabel.text = "fsadfsadfhaskdfhksahdfkljsahdfkljdsasdffasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfsadf"
        commentLabel.layer.backgroundColor = UIColor.lightGray2.cgColor
        commentLabel.font = .systemFont(ofSize: 12)
        commentLabel.isHidden = true
        commentLabel.textColor = .black
        commentLabel.numberOfLines = 0
        commentLabel.layer.cornerRadius = 16
        addSubview(commentLabel)

//        nameLabel.text = "\(media.comments[0].owner.firstName) \(media.comments[0].owner.lastName.prefix(0))"
        nameLabel.font = .systemFont(ofSize: 10)
        nameLabel.isHidden = true
        nameLabel.textColor = .mediumGray
        addSubview(nameLabel)

        dateLabel.text = "1d"
        dateLabel.isHidden = true
        dateLabel.font = .systemFont(ofSize: 10)
        dateLabel.textColor = .mediumGray
        addSubview(dateLabel)

        //        likeButton.addTarget(self, action: #selector(likeComment), for: .touchUpInside)
        likeButton.isHidden = true
        addSubview(likeButton)

        let heartImageSize = CGSize(width: 16, height: 14)
        let labelHeight: CGFloat = 12
        let profileImageSize = CGSize(width: 40, height: 40)
        let horizontalPadding: CGFloat = 20
        let verticalPadding: CGFloat = 8

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(profileImageSize)
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
        }

        nameLabel.snp.makeConstraints { make in
        //            make.bottom.equalTo(commentLabel.snp.top).offset(-4)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(labelHeight)
            make.leading.equalTo(commentLabel)
            make.trailing.equalToSuperview().inset(horizontalPadding)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.height.equalTo(labelHeight)
            make.leading.equalTo(nameLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(20)
        }

        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.trailing.equalToSuperview().inset(69)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.bottom.equalToSuperview().inset(12)
        }

        likeButton.snp.makeConstraints { make in
            make.size.equalTo(heartImageSize)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(commentLabel)

        }

        separatorView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(2)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(83)
            make.top.equalTo(separatorView.snp.bottom).offset(17)
        }

        seeAllCommentsButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(titleLabel)
            make.height.equalTo(15)
            make.leading.equalTo(titleLabel.snp.trailing)
        }

    }

    @objc func seeAllComments() {
        delegate?.seeAllComments()
    }

    func configure(with media: Media) {

        let numComments = media.comments.count

        seeAllCommentsButton.setTitle("See All \(numComments)", for: .normal)

        if numComments == 0 {
            return
        }

        seeAllCommentsButton.isHidden = false
        profileImageView.isHidden = false

        commentLabel.text = media.comments[0].message
        commentLabel.isHidden = false

        let firstName = media.comments[0].owner.firstName
        let lastName = media.comments[0].owner.lastName
        nameLabel.text = "\(firstName) \(lastName.prefix(1))."
        nameLabel.isHidden = false

        dateLabel.text = "1d"
        dateLabel.isHidden = false

        likeButton.setImage(UIImage(named: "heart"), for: .normal)
        likeButton.isHidden = false

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MediaThoughtsTableViewCell: CommentDelegate {
    func showSpoilerModal(commentText: String) {
//        let commentSpoilerModalView = CommentSpoilerModalView(comment: commentText)
//        commentSpoilerModalView.delegate = self
//        addSubview(commentSpoilerModalView)
    }

    func likeComment(index: Int) {
//        comments[index].liked.toggle()
//        commentsTableView.reloadData()
    }

    func addComment(commentText: String, isSpoiler: Bool) {
//        let comment = Comment(name: "Lucy", comment: commentText, date: "1d", liked: false)
//        comments.insert(comment, at: 0)
//        commentsTableView.reloadData()
    }

}

//extension MediaThoughtsTableViewCell: ModalDelegate {
//    func dismissModal(modalView: UIView) {
//        modalView.removeFromSuperview()
//    }
//}
