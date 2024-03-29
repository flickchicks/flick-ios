//
//  CommentAreaView.swift
//  Flick
//
//  Created by Lucy Xu on 8/1/20.
//  Copyright © 2020 flick. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

enum CommentAreaViewType {
    case preview, comment
}

class CommentAreaView: UIView {

    // MARK: - View Vars
    private let commentSeparatorView = UIView()
    let commentTextView = UITextView()
    private let sendCommentButton = UIButton()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )

    // MARK: - Data Vars
    weak var delegate: CommentDelegate?
    private var type: CommentAreaViewType

    init(type: CommentAreaViewType) {
        self.type = type
        super.init(frame: .zero)

        backgroundColor = .movieWhite

        commentSeparatorView.backgroundColor = .lightGray2
        addSubview(commentSeparatorView)

        commentTextView.text = "Share your thoughts"
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        commentTextView.backgroundColor = .lightGray2
        commentTextView.layer.cornerRadius = 15
        commentTextView.isScrollEnabled = false
        commentTextView.delegate = self
        commentTextView.textColor = .mediumGray
        commentTextView.sizeToFit()
        commentTextView.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        addSubview(commentTextView)

        sendCommentButton.setImage(UIImage(named: "send"), for: .normal)
        sendCommentButton.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        addSubview(sendCommentButton)

        spinner.isHidden = true
        addSubview(spinner)

        setupConstraints()

    }

    @objc func addComment() {
        if commentTextView.textColor == .mediumGray {
            return
        }
        commentTextView.resignFirstResponder()
        if let commentText = commentTextView.text, commentText.trimmingCharacters(in: .whitespaces) != "" {
            delegate?.addComment(commentText: commentText, isSpoiler: false)
//            delegate?.showSpoilerModal(commentText: commentText)
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
            make.trailing.equalToSuperview().inset(60)
            make.bottom.equalToSuperview().inset(textFieldVerticalPadding)
        }

        sendCommentButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
            make.leading.equalTo(commentTextView.snp.trailing)
            make.centerY.equalTo(commentTextView)
        }

    }

}

extension CommentAreaView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .mediumGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share your thoughts"
            textView.textColor = .mediumGray
        }
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        switch type {
        case .comment:
            return true
        case .preview:
            delegate?.seeAllComments()
            return false
        }
    }
    
}
