//
//  ReplyReactionViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 3/22/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class ReplyReactionViewController: UIViewController {

    // MARK: - Private View Vars
    private let dividerView4 = UIView()
    private let reactionTextView = UITextView()
    private let sendButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reply to Reaction"
        view.backgroundColor = .offWhite

        dividerView4.backgroundColor = .lightGray2
        view.addSubview(dividerView4)

        reactionTextView.textColor = .darkBlue
        reactionTextView.font = .systemFont(ofSize: 24)
        reactionTextView.tintColor = .black
        reactionTextView.backgroundColor = .clear
        view.addSubview(reactionTextView)

        sendButton.setTitle("Send", for: .normal)
        sendButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        sendButton.layer.cornerRadius = 20
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = .gradientPurple
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        view.addSubview(sendButton)

        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reactionTextView.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupConstraints() {
        let leadingTrailingPadding: CGFloat = 20
        let verticalPadding: CGFloat = 10

        reactionTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.bottom.equalTo(sendButton.snp.top).offset(-verticalPadding)
        }
        
        sendButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(40)
        }

        dividerView4.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(sendButton.snp.top).offset(-8)
            make.height.equalTo(1)
        }
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var bottomPadding: CGFloat = -10
            if #available(iOS 13.0, *) {
                let window = UIApplication.shared.windows.first
                if let padding = window?.safeAreaInsets.bottom {
                    bottomPadding += padding
                }
            }
            sendButton.snp.updateConstraints { update in
                update.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardSize.height - bottomPadding)
            }
        }
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        sendButton.snp.updateConstraints { update in
            update.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    @objc func sendButtonTapped() {
       print("send button tapped")
    }
}
