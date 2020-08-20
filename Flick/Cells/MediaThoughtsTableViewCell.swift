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

//        seeAllCommentsButton.setTitle("See All 4", for: .normal)
        seeAllCommentsButton.contentHorizontalAlignment = .right
        seeAllCommentsButton.addTarget(self, action: #selector(seeAllComments), for: .touchUpInside)
        seeAllCommentsButton.setTitleColor(.darkBlueGray2, for: .normal)
        seeAllCommentsButton.titleLabel?.font = .systemFont(ofSize: 12)
        addSubview(seeAllCommentsButton)

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

    }

    func configure(with media: Media) {
        let numComments = media.comments.count
        if numComments > 0 {
            seeAllCommentsButton.setTitle("See All \(numComments)", for: .normal)
            commentTableViewCell.configure(for: media.comments[0], index: 0, delegate: self)
            addSubview(commentTableViewCell)
            
            commentTableViewCell.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(12)
            }
        }
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
