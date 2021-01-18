//
//  AboutViewController.swift
//  Flick
//
//  Created by Lucy Xu on 1/18/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    // MARK: - Private View Vars
    private let attributionsSubtitleLabel = UILabel()
    private let attributionsTitleLabel = UILabel()
    private let headerView = UIView()
    private let privacyPolicyButton = UIButton()
    private let privacyPolicyLabel = UILabel()
    private let tmdBImageView = UIImageView(image: UIImage(named: "tmdB"))

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "About"
        view.backgroundColor = .offWhite

        headerView.backgroundColor = .movieWhite
        headerView.clipsToBounds = false
        headerView.layer.masksToBounds = false
        headerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        headerView.layer.shadowOpacity = 0.07
        headerView.layer.shadowOffset = .init(width: 0, height: 4)
        headerView.layer.shadowRadius = 8
        view.addSubview(headerView)

        privacyPolicyLabel.text = "Privacy Policy"
        privacyPolicyLabel.textColor = .black
        privacyPolicyLabel.font = .systemFont(ofSize: 18)
        view.addSubview(privacyPolicyLabel)
        
        privacyPolicyButton.setImage(UIImage(named: "rightChevron"), for: .normal)
        privacyPolicyButton.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)
        view.addSubview(privacyPolicyButton)
        
        attributionsTitleLabel.text = "Attributions"
        attributionsTitleLabel.textColor = .black
        attributionsTitleLabel.font = .systemFont(ofSize: 18)
        view.addSubview(attributionsTitleLabel)
        
        attributionsSubtitleLabel.text = "We use TMDb to gather all the movies and shows you see."
        attributionsSubtitleLabel.textColor = .black
        attributionsSubtitleLabel.font = .systemFont(ofSize: 12)
        attributionsTitleLabel.numberOfLines = 0
        view.addSubview(attributionsSubtitleLabel)
        
        view.addSubview(tmdBImageView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        // set up pop gestrue
    }

    private func setupConstraints() {
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(10)
        }

        privacyPolicyLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalTo(privacyPolicyButton.snp.leading)
            make.height.equalTo(22)
        }
        
        privacyPolicyButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 4, height: 9))
            make.centerY.equalTo(privacyPolicyLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        attributionsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(privacyPolicyLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        
        attributionsSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(attributionsTitleLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(15)
        }
        
        tmdBImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 132, height: 11))
            make.top.equalTo(attributionsSubtitleLabel.snp.bottom).offset(15)
            make.leading.equalTo(attributionsTitleLabel)
        }
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)

        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()

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

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showPrivacyPolicy() {
        //TODO: Add link later
        print("showPrivacyPolicy")
    }

}
