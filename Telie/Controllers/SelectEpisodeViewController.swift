//
//  CreateReactionViewController.swift
//  Telie
//
//  Created by Alanna Zhou on 3/4/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class SelectEpisodeViewController: UIViewController {

    // MARK: - Private View Vars
    private let browseButton = UIButton()
    private let seasonButton = UIButton()
    private let season2Button = UIButton()
    private let dividerView1 = UIView()
    private let dividerView2 = UIView()
//    private let dividerView3 = UIView()
//    private let dividerView4 = UIView()
//    private let downButton = UIButton()
    private let episodeLabel = UILabel()
//    private let episodeTextLabel = UILabel()
    private let episodeButton = UIButton()
    private let episode2Button = UIButton()
    private let episode2TextLabel = UILabel()
    private let titleLabel = UILabel()
    private let titleTextLabel = UILabel()
//    private let upButton = UIButton()
//    private let visibilityButton = UIButton()

    // MARK: - Private Data Var
//    private var visibility = Visibility.friends
//    private var isSpoiler = true

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Episode"
        view.backgroundColor = .offWhite

        titleLabel.text = "Season"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        view.addSubview(titleLabel)

//        titleTextLabel.text = "Avatar: The Last Airbender"
//        titleTextLabel.textColor = .darkBlue
//        titleTextLabel.font = .systemFont(ofSize: 16)
//        view.addSubview(titleTextLabel)

        seasonButton.setTitle("Season 1", for: .normal)
        seasonButton.setTitleColor(.darkPurple, for: .normal)
        seasonButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        seasonButton.backgroundColor = .lightPurple
        seasonButton.layer.borderColor = UIColor.darkPurple.cgColor
        seasonButton.layer.borderWidth = 1
        seasonButton.layer.cornerRadius = 13
        view.addSubview(seasonButton)
        
        season2Button.setTitle("Season 2", for: .normal)
        season2Button.setTitleColor(.darkPurple, for: .normal)
        season2Button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        season2Button.backgroundColor = .none
        season2Button.layer.borderColor = UIColor.darkPurple.cgColor
        season2Button.layer.borderWidth = 1
        season2Button.layer.cornerRadius = 13
        view.addSubview(season2Button)

        episodeLabel.text = "Episode"
        episodeLabel.textColor = .black
        episodeLabel.font = .systemFont(ofSize: 14, weight: .bold)
        view.addSubview(episodeLabel)

//        episodeTextLabel.text = "1. The Boy in the Iceberg"
//        episodeTextLabel.textColor = .darkBlue
//        episodeTextLabel.font = .systemFont(ofSize: 18)
//        view.addSubview(episodeTextLabel)
        
        episodeButton.setTitle("1. The Boy in the Iceberg", for: .normal)
        episodeButton.setTitleColor(.darkBlue, for: .normal)
        episodeButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        episodeButton.backgroundColor = .none
        episodeButton.layer.cornerRadius = 8
        episodeButton.contentHorizontalAlignment = .left
        episodeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        view.addSubview(episodeButton)

//        episode2TextLabel.text = "2. The Avatar Returns"
//        episode2TextLabel.textColor = .darkBlue
//        episode2TextLabel.font = .systemFont(ofSize: 18)
//        view.addSubview(episode2TextLabel)
        
        episode2Button.setTitle("2. The Avatar Returns", for: .normal)
        episode2Button.setTitleColor(.darkBlue, for: .normal)
        episode2Button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        episode2Button.backgroundColor = .lightGray2
        episode2Button.layer.cornerRadius = 8
        episode2Button.contentHorizontalAlignment = .left
        episode2Button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        view.addSubview(episode2Button)

        browseButton.setTitle("Browse", for: .normal)
        browseButton.setTitleColor(.darkBlueGray2, for: .normal)
        browseButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        browseButton.backgroundColor = .lightGray2
        browseButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
        browseButton.layer.borderWidth = 1
        browseButton.layer.cornerRadius = 13
        view.addSubview(browseButton)

//        upButton.setImage(UIImage(named: "arrowUp"), for: .normal)
//        upButton.backgroundColor = .lightGray2
//        upButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
//        upButton.layer.borderWidth = 1
//        upButton.layer.cornerRadius = 13
//        view.addSubview(upButton)

//        downButton.setImage(UIImage(named: "arrowDown"), for: .normal)
//        downButton.backgroundColor = .lightGray2
//        downButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
//        downButton.layer.borderWidth = 1
//        downButton.layer.cornerRadius = 13
//        view.addSubview(downButton)

        dividerView1.backgroundColor = .none
        view.addSubview(dividerView1)

        dividerView2.backgroundColor = .none
        view.addSubview(dividerView2)

//        dividerView3.backgroundColor = .lightGray2
//        view.addSubview(dividerView3)
//
//        dividerView4.backgroundColor = .lightGray2
//        view.addSubview(dividerView4)

//        visibilityButton.setTitle("Visible to Friends  ", for: .normal)
//        visibilityButton.setTitleColor(.mediumGray, for: .normal)
//        visibilityButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
//        visibilityButton.setImage(UIImage(named: "downChevron"), for: .normal)
//        visibilityButton.semanticContentAttribute = .forceRightToLeft
//        visibilityButton.layer.borderWidth = 1
//        visibilityButton.layer.borderColor = UIColor.mediumGray.cgColor
//        visibilityButton.layer.cornerRadius = 12
//        visibilityButton.addTarget(self, action: #selector(visibilityButtonTapped), for: .touchUpInside)
//        view.addSubview(visibilityButton)

        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           setupNavigationBar()
       }
    
    private func setupNavigationBar() {
            let backButtonSize = CGSize(width: 22, height: 18)

            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationBar.barTintColor = .movieWhite
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.layer.masksToBounds = false
            navigationController?.navigationBar.layer.shadowColor = UIColor.blueGrayShadow.cgColor
            navigationController?.navigationBar.layer.shadowOpacity = 0.07
            navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
            navigationController?.navigationBar.layer.shadowRadius = 8
            navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)

            let backButton = UIButton()
            backButton.setImage(UIImage(named: "backArrow"), for: .normal)
            backButton.tintColor = .black
            backButton.snp.makeConstraints { make in
                make.size.equalTo(backButtonSize)
            }

            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
            let backBarButtonItem = UIBarButtonItem(customView: backButton)
            navigationItem.leftBarButtonItem = backBarButtonItem
        }
    
    @objc private func backButtonPressed() {
            navigationController?.popViewController(animated: true)
        }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }

    private func setupConstraints() {
        let leadingTrailingPadding: CGFloat = 20
        let verticalPadding: CGFloat = 11

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
//            make.trailing.equalTo(seasonButton.snp.leading).offset(leadingTrailingPadding)
        }

//        titleTextLabel.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(6)
//            make.leading.equalToSuperview().offset(leadingTrailingPadding)
//        }
        
        seasonButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
            make.height.equalTo(26)
            make.width.equalTo(78)
        }
        
        season2Button.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(seasonButton.snp.trailing).offset(10)
//            make.leading.equalToSuperview().offset(leadingTrailingPadding + 100)
            make.height.equalTo(26)
            make.width.equalTo(78)
        }

//        seasonButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(leadingTrailingPadding)
//            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
//            make.height.equalTo(26)
//            make.width.equalTo(68)
//        }

        dividerView1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(seasonButton.snp.bottom).offset(verticalPadding)
            make.height.equalTo(1)
        }

        episodeLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView1.snp.bottom).offset(verticalPadding)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
        }
        
        episodeButton.snp.makeConstraints { make in
            make.top.equalTo(episodeLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
            make.height.equalTo(37)
            make.width.equalTo(350)
        }

//        episodeTextLabel.snp.makeConstraints { make in
//            make.top.equalTo(episodeLabel.snp.bottom).offset(18)
//            make.leading.equalToSuperview().offset(leadingTrailingPadding)
//        }
//
        episode2Button.snp.makeConstraints { make in
            make.top.equalTo(episodeButton.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(leadingTrailingPadding)
            make.height.equalTo(37)
            make.width.equalTo(350)
        }

//        browseButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview().inset(leadingTrailingPadding)
//            make.top.equalTo(dividerView1).offset(24)
//            make.height.equalTo(26)
//            make.width.equalTo(68)
//        }

//        upButton.snp.makeConstraints { make in
//            make.trailing.equalTo(browseButton.snp.leading).offset(-10)
//            make.top.equalTo(dividerView1).offset(24)
//            make.height.equalTo(26)
//            make.width.equalTo(32)
//        }
//
//        downButton.snp.makeConstraints { make in
//            make.trailing.equalTo(upButton.snp.leading).offset(-10)
//            make.top.equalTo(dividerView1).offset(24)
//            make.height.equalTo(26)
//            make.width.equalTo(32)
//        }

        dividerView2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(episodeButton.snp.bottom).offset(verticalPadding)
            make.height.equalTo(1)
        }
//
//
//        dividerView3.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(visibilityButton.snp.top).offset(-8)
//            make.height.equalTo(1)
//        }

//        visibilityButton.snp.makeConstraints { make in
//            make.bottom.equalTo(dividerView4.snp.top).offset(-8)
//            make.leading.equalToSuperview().inset(leadingTrailingPadding)
//            make.size.equalTo(CGSize(width: 140, height: 24))
//        }



    }

//    @objc func keyboardWillShow(sender: NSNotification) {
//        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            var bottomPadding: CGFloat = -10
//            if #available(iOS 13.0, *) {
//                let window = UIApplication.shared.windows.first
//                if let padding = window?.safeAreaInsets.bottom {
//                    bottomPadding += padding
//                }
//            }
//            sendButton.snp.updateConstraints { update in
//                update.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(keyboardSize.height - bottomPadding)
//            }
//
//        }
//    }

//    @objc func sendButtonTapped() {
//        print("send tapped")
//    }

//    @objc func visibilityButtonTapped() {
//        let friendsAction = UIAlertAction(title: "Just My Friends", style: .default) { [weak self] action in
//            guard let self = self else { return }
//            self.visibility = Visibility.friends
//            self.visibilityButton.setTitle("Visible to Friends  ", for: .normal)
//        }
//        let anyoneAction = UIAlertAction(title: "Anyone", style: .default) { [weak self] action in
//            guard let self = self else { return }
//            self.visibility = Visibility.public
//            self.visibilityButton.setTitle("Visible to Anyone  ", for: .normal)
//        }
//
//        let visibilityAlert = UIAlertController(title: "Visibility", message: nil, preferredStyle: .actionSheet)
//
//        visibilityAlert.addAction(friendsAction)
//        visibilityAlert.addAction(anyoneAction)
//
//        self.present(visibilityAlert, animated: true)
//    }

//    @objc func spoilerButtonTapped() {
//        let hasSpoilerAction = UIAlertAction(title: "Contains Spoilers", style: .default) { [weak self] action in
//            guard let self = self else { return }
//            self.isSpoiler = true
//            self.spoilerButton.setTitle("Contains Spoiler  ", for: .normal)
//        }
//        let noSpoilerAction = UIAlertAction(title: "No Spoilers", style: .default) { [weak self] action in
//            guard let self = self else { return }
//            self.isSpoiler = false
//            self.spoilerButton.setTitle("No Spoiler  ", for: .normal)
//        }
//
//        let spoilerAlert = UIAlertController(title: "Spoiler Content", message: nil, preferredStyle: .actionSheet)
//
//        spoilerAlert.addAction(hasSpoilerAction)
//        spoilerAlert.addAction(noSpoilerAction)
//
//        self.present(spoilerAlert, animated: true)
//    }

}
