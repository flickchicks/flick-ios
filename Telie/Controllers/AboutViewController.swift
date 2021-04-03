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
    private let privacyPolicyButton = UIButton()
    private let privacyPolicyLabel = UILabel()
    private let rightChevronImageView = UIImageView()
    private let tmdBImageView = UIImageView(image: UIImage(named: "tmdB"))

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "About"
        view.backgroundColor = .offWhite

        privacyPolicyButton.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)
        view.addSubview(privacyPolicyButton)

        privacyPolicyLabel.text = "Privacy Policy"
        privacyPolicyLabel.textColor = .black
        privacyPolicyLabel.font = .systemFont(ofSize: 18)
        privacyPolicyButton.addSubview(privacyPolicyLabel)

        rightChevronImageView.image = UIImage(named: "rightChevron")
        rightChevronImageView.isUserInteractionEnabled = false
        privacyPolicyButton.addSubview(rightChevronImageView)
        
        attributionsTitleLabel.text = "Attributions"
        attributionsTitleLabel.textColor = .black
        attributionsTitleLabel.font = .systemFont(ofSize: 18)
        view.addSubview(attributionsTitleLabel)
        
        attributionsSubtitleLabel.text = "We use TMDb to gather all the movies and shows you see."
        attributionsSubtitleLabel.textColor = .black
        attributionsSubtitleLabel.font = .systemFont(ofSize: 12)
        attributionsSubtitleLabel.numberOfLines = 0
        view.addSubview(attributionsSubtitleLabel)
        
        view.addSubview(tmdBImageView)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func setupConstraints() {

        privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }

        privacyPolicyLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }
        
        rightChevronImageView.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.width.equalTo(5)
            make.height.equalTo(10)
        }
        
        attributionsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(privacyPolicyLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(22)
        }
        
        attributionsSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(attributionsTitleLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(24)
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

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func showPrivacyPolicy() {
        if let url = URL(string: "https://telie.app/privacy/") {
            UIApplication.shared.open(url)
        }
    }

}
