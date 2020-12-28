//
//  CommentSpoilerModalView.swift
//  Flick
//
//  Created by Lucy Xu on 8/20/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class CommentSpoilerModalView: UIView {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private var noButton = UIButton()
    private var yesButton = UIButton()
    private let titleLabel = UILabel()
    private let commentTextView = UITextView()

    // MARK: - Private Data Var
    weak var delegate: ModalDelegate?
    weak var commentDelegate: CommentDelegate?

    private var comment: String!

    init(comment: String) {
        self.comment = comment
        super.init(frame: .zero)

        frame = UIScreen.main.bounds
        backgroundColor = UIColor.darkBlueGray2.withAlphaComponent(0.7)

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        addSubview(containerView)

        titleLabel.text = "Does this contain a spoiler?"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(titleLabel)

        commentTextView.text = comment
        commentTextView.isEditable = false
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        commentTextView.backgroundColor = .lightGray2
        commentTextView.layer.cornerRadius = 15
        commentTextView.isScrollEnabled = false
        commentTextView.textColor = .black
        commentTextView.sizeToFit()
        commentTextView.font = .systemFont(ofSize: 12, weight: .regular)
        containerView.addSubview(commentTextView)

        noButton = RoundedButton(style: .purple, title: "No")
        noButton.addTarget(self, action: #selector(noButtonPressed), for: .touchUpInside)
        containerView.addSubview(noButton)

        yesButton = RoundedButton(style: .purple, title: "Yes")
        yesButton.addTarget(self, action: #selector(yesButtonPressed), for: .touchUpInside)
        containerView.addSubview(yesButton)

        setupConstraints()

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })
    }

    func setupConstraints() {
        let buttonSize = CGSize(width: 70, height: 40)
        let buttonHorizontalPadding = 64
        let verticalPadding = 36

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(verticalPadding)
        }

        commentTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }

        yesButton.snp.makeConstraints { make in
            make.top.equalTo(commentTextView.snp.bottom).offset(31)
            make.bottom.equalToSuperview().inset(verticalPadding)
            make.size.equalTo(buttonSize)
            make.leading.equalToSuperview().offset(buttonHorizontalPadding)
        }

        noButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(yesButton)
            make.size.equalTo(buttonSize)
            make.trailing.equalToSuperview().inset(buttonHorizontalPadding)
        }

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(308)
        }
    }

    @objc func noButtonPressed() {
        commentDelegate?.addComment(commentText: comment, isSpoiler: false)
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.delegate?.dismissModal(modalView: self)
        }
    }

    @objc func yesButtonPressed() {
        commentDelegate?.addComment(commentText: comment, isSpoiler: true)
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.delegate?.dismissModal(modalView: self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
