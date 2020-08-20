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
    private let commentTextView = UITextView()
    private let sendCommentButton = UIButton()
    weak var delegate: CommentDelegate?
//    weak var modalDelegate: ModalDelegate?

    override init(frame: CGRect) {
        super.init(frame: .zero)

        backgroundColor = .movieWhite

        commentSeparatorView.backgroundColor = .lightGray2
        addSubview(commentSeparatorView)

        commentTextView.text = ""
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        commentTextView.backgroundColor = .lightGray2
        commentTextView.layer.cornerRadius = 15
        commentTextView.isScrollEnabled = false
        commentTextView.textColor = .black
        commentTextView.sizeToFit()
        commentTextView.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        addSubview(commentTextView)

        sendCommentButton.setImage(UIImage(named: "send"), for: .normal)
        sendCommentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        addSubview(sendCommentButton)

        setupConstraints()

    }

    @objc func addComment() {
        print("add comment")
        if let commentText = commentTextView.text, commentText.trimmingCharacters(in: .whitespaces) != "" {
            print(commentText)
            delegate?.showSpoilerModal(commentText: commentText)
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

        commentTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(textFieldVerticalPadding)
            make.leading.equalToSuperview().offset(28)
//            make.height.equalTo(commentTextView.contentSize.height)
            make.trailing.equalToSuperview().inset(60)
            make.bottom.equalToSuperview().inset(textFieldVerticalPadding)
        }

        sendCommentButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leading.equalTo(commentTextView.snp.trailing).offset(14)
            make.centerY.equalTo(commentTextView)
        }

    }

}

//extension CommentAreaView: ModalDelegate {
//
//    func dismissModal(modalView: UIView) {
//        modalView.removeFromSuperview()
//    }
//
//}
