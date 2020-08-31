//
//  ProfileSelectionModalView.swift
//  Flick
//
//  Created by Lucy Xu on 8/31/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol ProfileSelectionDelegate: class {
    func selectFromGallery()
    func takeNewPhoto()
}

class ProfileSelectionModalView: UIView {

    // MARK: - Private View Vars
    private let cancelButton = UIButton()
    private let containerView = UIView()
    private let galleryButton = UIButton()
    private let newPhotoButton = UIButton()
    private let titleLabel = UILabel()

    // MARK: - Private Data Var
    weak var modalDelegate: ModalDelegate?
    weak var profileSelectionDelegate: ProfileSelectionDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds

        containerView.backgroundColor = .movieWhite
        containerView.layer.cornerRadius = 24
        // TODO: Double check shadows
        containerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        containerView.layer.shadowOpacity = 0.07
        containerView.layer.shadowOffset = .init(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        
        addSubview(containerView)

        titleLabel.text = "Upload Profile Photo"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(titleLabel)

        galleryButton.setTitleColor(.black, for: .normal)
        galleryButton.setTitle("Choose from Gallery", for: .normal)
        galleryButton.addTarget(self, action: #selector(selectFromGallery), for: .touchUpInside)
        galleryButton.titleLabel?.font = .systemFont(ofSize: 16)
        containerView.addSubview(galleryButton)

        newPhotoButton.setTitleColor(.black, for: .normal)
        newPhotoButton.setTitle("Take a new photo", for: .normal)
        newPhotoButton.addTarget(self, action: #selector(takeNewPhoto), for: .touchUpInside)
        newPhotoButton.titleLabel?.font = .systemFont(ofSize: 16)
        containerView.addSubview(newPhotoButton)

        cancelButton.setTitleColor(.mediumGray, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 14)
        cancelButton.addTarget(self, action: #selector(cancelPhotoSelection), for: .touchUpInside)
        containerView.addSubview(cancelButton)

        setupConstraints()

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })
    }

    func setupConstraints() {
        let verticalPadding = 36
        let containerViewSize = CGSize(width: 275, height: 241)
        let buttonHeight = 19

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(verticalPadding)
        }

        galleryButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.top.equalTo(titleLabel.snp.bottom).offset(verticalPadding)
        }

        newPhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.top.equalTo(galleryButton.snp.bottom).offset(20)
        }

        cancelButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(17)
            make.top.equalTo(newPhotoButton.snp.bottom).offset(verticalPadding)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(189)
            make.centerX.equalToSuperview()
            make.size.equalTo(containerViewSize)
        }
    }

    @objc func cancelPhotoSelection() {
        modalDelegate?.dismissModal(modalView: self)
    }

    @objc func selectFromGallery() {
        profileSelectionDelegate?.selectFromGallery()
    }

    @objc func takeNewPhoto() {
        profileSelectionDelegate?.takeNewPhoto()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
