//
//  CreateReactionViewController.swift
//  Telie
//
//  Created by Haiying W on 2/19/22.
//  Copyright © 2022 Telie. All rights reserved.
//

import UIKit

class CreateReactionViewController: UIViewController {

    private let titleLabel = UILabel()
    private let titleTextLabel = UILabel()
    private let episodeLabel = UILabel()
    private let episodeTextLabel = UILabel()
    private let changeButton = UIButton()
    private let browseButton = UIButton()
    private let upButton = UIButton()
    private let downButton = UIButton()
    private let dividerView1 = UIView()
    private let dividerView2 = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Share Reactions"
        view.backgroundColor = .offWhite

        titleLabel.text = "Title"
        titleLabel.textColor = .mediumGray
        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        view.addSubview(titleLabel)

        titleTextLabel.text = "Avatar: The Last Airbender"
        titleTextLabel.textColor = .darkBlue
        titleTextLabel.font = .systemFont(ofSize: 20)
        view.addSubview(titleTextLabel)

        changeButton.setTitle("Change", for: .normal)
        changeButton.setTitleColor(.darkBlueGray2, for: .normal)
        changeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        changeButton.backgroundColor = .lightGray2
        changeButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
        changeButton.layer.borderWidth = 1
        changeButton.layer.cornerRadius = 13
        view.addSubview(changeButton)

        episodeLabel.text = "Episode"
        episodeLabel.textColor = .mediumGray
        episodeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        view.addSubview(episodeLabel)

        episodeTextLabel.text = "Season 1 Episode 7"
        episodeTextLabel.textColor = .darkBlue
        episodeTextLabel.font = .systemFont(ofSize: 20)
        view.addSubview(episodeTextLabel)

        browseButton.setTitle("Browse", for: .normal)
        browseButton.setTitleColor(.darkBlueGray2, for: .normal)
        browseButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
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

        setupConstraints()
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

    }

}
