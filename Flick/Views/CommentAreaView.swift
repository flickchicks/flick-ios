//
//  CommentAreaView.swift
//  Flick
//
//  Created by Lucy Xu on 8/1/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class CommentAreaView: UIView {

    // MARK: - Private View Vars
    private let commentSeparatorView = UIView()
    private let commentTextField = UITextField()
    private let sendCommentButton = UIButton()
    weak var delegate: CommentDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)

        backgroundColor = .movieWhite

        commentSeparatorView.backgroundColor = .lightGray2
        addSubview(commentSeparatorView)

        commentTextField.backgroundColor = .lightGray2
        commentTextField.layer.cornerRadius = 15
        commentTextField.placeholder = "Share your thoughts"
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: commentTextField.frame.height))
        commentTextField.leftView = leftPaddingView
        commentTextField.leftViewMode = .always
        commentTextField.textColor = .black
        commentTextField.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        addSubview(commentTextField)

        sendCommentButton.setImage(UIImage(named: "send"), for: .normal)
        sendCommentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        addSubview(sendCommentButton)

        setupConstraints()

    }

    @objc func addComment() {
        if let commentText = commentTextField.text, commentText.trimmingCharacters(in: .whitespaces) != "" {
            delegate?.addComment(commentText: commentText)
//            let comment = Comment(name: "Lucy", comment: commentText, date: "1d", liked: false)
//            comments.insert(comment, at: 0)
//            commentsTableView.reloadData()
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

        let textFieldVerticalPadding = 16

        commentSeparatorView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(2)
        }

        commentTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(textFieldVerticalPadding)
            make.leading.equalToSuperview().offset(28)
            make.trailing.equalToSuperview().inset(60)
            make.bottom.equalToSuperview().inset(textFieldVerticalPadding)
        }

        sendCommentButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalTo(commentTextField.snp.trailing).offset(14)
            make.centerY.equalTo(commentTextField)
        }

    }

}
