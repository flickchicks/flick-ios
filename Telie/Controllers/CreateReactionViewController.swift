//
//  CreateReactionViewController.swift
//  Telie
//
//  Created by Haiying W on 2/19/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class CreateReactionViewController: UIViewController {

    // MARK: - Private View Vars
    private let browseButton = UIButton()
    private let changeButton = UIButton()
    private let dividerView1 = UIView()
    private let dividerView2 = UIView()
    private let dividerView3 = UIView()
    private let dividerView4 = UIView()
    private let downButton = UIButton()
    private let episodeLabel = UILabel()
    private let episodeTextLabel = UILabel()
    private let reactionTextView = UITextView()
    private let sendButton = UIButton()
    private let spoilerButton = UIButton()
    private let titleLabel = UILabel()
    private let titleTextLabel = UILabel()
    private let upButton = UIButton()
    private let visibilityButton = UIButton()

    // MARK: - Private Data Var
    private var visibility = Visibility.friends
    private var isSpoiler = true

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Share Reactions"
        view.backgroundColor = .offWhite

        titleLabel.text = "Title"
        titleLabel.textColor = .mediumGray
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        view.addSubview(titleLabel)

        titleTextLabel.text = "Avatar: The Last Airbender"
        titleTextLabel.textColor = .darkBlue
        titleTextLabel.font = .systemFont(ofSize: 16)
        view.addSubview(titleTextLabel)

        changeButton.setTitle("Change", for: .normal)
        changeButton.setTitleColor(.darkBlueGray2, for: .normal)
        changeButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        changeButton.backgroundColor = .lightGray2
        changeButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
        changeButton.layer.borderWidth = 1
        changeButton.layer.cornerRadius = 13
        view.addSubview(changeButton)

        episodeLabel.text = "Episode"
        episodeLabel.textColor = .mediumGray
        episodeLabel.font = .systemFont(ofSize: 12, weight: .medium)
        view.addSubview(episodeLabel)

        episodeTextLabel.text = "Season 1 Episode 7"
        episodeTextLabel.textColor = .darkBlue
        episodeTextLabel.font = .systemFont(ofSize: 16)
        view.addSubview(episodeTextLabel)

        browseButton.setTitle("Browse", for: .normal)
        browseButton.setTitleColor(.darkBlueGray2, for: .normal)
        browseButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        browseButton.backgroundColor = .lightGray2
        browseButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
        browseButton.layer.borderWidth = 1
        browseButton.layer.cornerRadius = 13
        view.addSubview(browseButton)

        upButton.setImage(UIImage(named: "arrowUp"), for: .normal)
        upButton.backgroundColor = .lightGray2
        upButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
        upButton.layer.borderWidth = 1
        upButton.layer.cornerRadius = 13
        view.addSubview(upButton)

        downButton.setImage(UIImage(named: "arrowDown"), for: .normal)
        downButton.backgroundColor = .lightGray2
        downButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
        downButton.layer.borderWidth = 1
        downButton.layer.cornerRadius = 13
        view.addSubview(downButton)

        dividerView1.backgroundColor = .lightGray2
        view.addSubview(dividerView1)

        dividerView2.backgroundColor = .lightGray2
        view.addSubview(dividerView2)

        dividerView3.backgroundColor = .lightGray2
        view.addSubview(dividerView3)

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

        visibilityButton.setTitle("Visible to Friends  ", for: .normal)
        visibilityButton.setTitleColor(.mediumGray, for: .normal)
        visibilityButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        visibilityButton.setImage(UIImage(named: "downChevron"), for: .normal)
        visibilityButton.semanticContentAttribute = .forceRightToLeft
        visibilityButton.layer.borderWidth = 1
        visibilityButton.layer.borderColor = UIColor.mediumGray.cgColor
        visibilityButton.layer.cornerRadius = 12
        visibilityButton.addTarget(self, action: #selector(visibilityButtonTapped), for: .touchUpInside)
        view.addSubview(visibilityButton)

//        spoilerButton.setTitle("Contains Spoiler  ", for: .normal)
//        spoilerButton.setTitleColor(.mediumGray, for: .normal)
//        spoilerButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
//        spoilerButton.setImage(UIImage(named: "downChevron"), for: .normal)
//        spoilerButton.semanticContentAttribute = .forceRightToLeft
//        spoilerButton.layer.borderWidth = 1
//        spoilerButton.layer.borderColor = UIColor.mediumGray.cgColor
//        spoilerButton.layer.cornerRadius = 12
//        spoilerButton.addTarget(self, action: #selector(spoilerButtonTapped), for: .touchUpInside)
//        view.addSubview(spoilerButton)

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

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
            make.trailing.equalTo(changeButton.snp.leading).offset(leadingTrailingPadding)
        }

        titleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
        }

        changeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.height.equalTo(26)
            make.width.equalTo(68)
        }

        dividerView1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleTextLabel.snp.bottom).offset(verticalPadding)
            make.height.equalTo(1)
        }

        episodeLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView1.snp.bottom).offset(verticalPadding)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
        }

        episodeTextLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
            make.trailing.equalTo(downButton.snp.leading).offset(leadingTrailingPadding)
        }

        browseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.top.equalTo(dividerView1).offset(24)
            make.height.equalTo(26)
            make.width.equalTo(68)
        }

        upButton.snp.makeConstraints { make in
            make.trailing.equalTo(browseButton.snp.leading).offset(-10)
            make.top.equalTo(dividerView1).offset(24)
            make.height.equalTo(26)
            make.width.equalTo(32)
        }

        downButton.snp.makeConstraints { make in
            make.trailing.equalTo(upButton.snp.leading).offset(-10)
            make.top.equalTo(dividerView1).offset(24)
            make.height.equalTo(26)
            make.width.equalTo(32)
        }

        dividerView2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(episodeTextLabel.snp.bottom).offset(verticalPadding)
            make.height.equalTo(1)
        }

        reactionTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingPadding)
            make.top.equalTo(dividerView2.snp.bottom).offset(20)
            make.bottom.equalTo(dividerView3.snp.top).offset(-verticalPadding)
        }

        dividerView3.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(visibilityButton.snp.top).offset(-8)
            make.height.equalTo(1)
        }

        visibilityButton.snp.makeConstraints { make in
            make.bottom.equalTo(dividerView4.snp.top).offset(-8)
            make.leading.equalToSuperview().inset(leadingTrailingPadding)
            make.size.equalTo(CGSize(width: 140, height: 24))
        }

//        spoilerButton.snp.makeConstraints { make in
//            make.bottom.equalTo(dividerView4.snp.top).offset(-8)
//            make.leading.equalTo(visibilityButton.snp.trailing).offset(leadingTrailingPadding)
//            make.size.equalTo(CGSize(width: 130, height: 24))
//        }

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
        print("send tapped")
    }

    @objc func visibilityButtonTapped() {
        let friendsAction = UIAlertAction(title: "Just My Friends", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.visibility = Visibility.friends
            self.visibilityButton.setTitle("Visible to Friends  ", for: .normal)
        }
        let anyoneAction = UIAlertAction(title: "Anyone", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.visibility = Visibility.public
            self.visibilityButton.setTitle("Visible to Anyone  ", for: .normal)
        }

        let visibilityAlert = UIAlertController(title: "Visibility", message: nil, preferredStyle: .actionSheet)

        visibilityAlert.addAction(friendsAction)
        visibilityAlert.addAction(anyoneAction)

        self.present(visibilityAlert, animated: true)
    }

    @objc func spoilerButtonTapped() {
        let hasSpoilerAction = UIAlertAction(title: "Contains Spoilers", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.isSpoiler = true
            self.spoilerButton.setTitle("Contains Spoiler  ", for: .normal)
        }
        let noSpoilerAction = UIAlertAction(title: "No Spoilers", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.isSpoiler = false
            self.spoilerButton.setTitle("No Spoiler  ", for: .normal)
        }

        let spoilerAlert = UIAlertController(title: "Spoiler Content", message: nil, preferredStyle: .actionSheet)

        spoilerAlert.addAction(hasSpoilerAction)
        spoilerAlert.addAction(noSpoilerAction)

        self.present(spoilerAlert, animated: true)
    }

}
