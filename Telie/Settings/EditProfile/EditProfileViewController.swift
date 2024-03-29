//
//  EditProfileViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import Kingfisher
import NotificationBannerSwift
import NVActivityIndicatorView

protocol EditProfileDelegate: class {
    func updateUser(user: UserProfile)
}

class EditProfileViewController: UIViewController {

    // MARK: - Private View Vars
    private let accountInfoDescriptionLabel = UILabel()
    private let accountInfoTitleLabel = UILabel()
    private let backButton = UIButton()
    private let bioFieldLabel = UILabel()
    private let bioTextView = UITextView()
    private let bioTextLimitLabel = UILabel()
    private let linkedAccountLabel = UILabel()
    private let linkedAccountFieldLabel = UILabel()
    private let imagePickerController = UIImagePickerController()
    private let nameFieldLabel = UILabel()
    private let nameTextField = ProfileInputTextField()
    private let profileImageView = UIImageView()
    private let saveButton = UIButton()
    private let selectImageButton = UIButton()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let userNameFieldLabel = UILabel()
    private let userNameTextField = ProfileInputTextField()

    // MARK: - Data Vars
    private let backButtonSize = CGSize(width: 22, height: 18)
    weak var delegate: EditProfileDelegate?
    private var didChangeProfilePic = false
    private let profileImageSize = CGSize(width: 100, height: 100)
    private let saveButtonSize = CGSize(width: 33, height: 17)
    private var user: UserProfile

    init(user: UserProfile) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Edit Profile"
        view.backgroundColor = .offWhite

        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = ["public.image"]

        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
        if let imageUrl = URL(string: user.profilePicUrl ?? Constants.User.defaultImage) {
            profileImageView.kf.setImage(with: imageUrl)
        } else {
            profileImageView.kf.setImage(with: URL(string: Constants.User.defaultImage))
        }
        view.addSubview(profileImageView)

        selectImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        selectImageButton.setImage(UIImage(named: "editButton"), for: .normal)
        selectImageButton.clipsToBounds = false
        selectImageButton.layer.masksToBounds = false
        selectImageButton.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        selectImageButton.layer.shadowOpacity = 0.07
        selectImageButton.layer.shadowOffset = .init(width: 0, height: 1)
        selectImageButton.layer.shadowRadius = 4
        view.addSubview(selectImageButton)

        nameFieldLabel.text = "Name"
        nameFieldLabel.font = .systemFont(ofSize: 10)
        nameFieldLabel.textColor = .mediumGray
        view.addSubview(nameFieldLabel)

        nameTextField.text = user.name
        nameTextField.delegate = self
        view.addSubview(nameTextField)

        userNameFieldLabel.text = "Username"
        userNameFieldLabel.font = .systemFont(ofSize: 10)
        userNameFieldLabel.textColor = .mediumGray
        view.addSubview(userNameFieldLabel)

        userNameTextField.text = user.username
        userNameTextField.delegate = self
        view.addSubview(userNameTextField)

        bioFieldLabel.text = "Bio"
        bioFieldLabel.font = .systemFont(ofSize: 10)
        bioFieldLabel.textColor = .mediumGray
        view.addSubview(bioFieldLabel)

        bioTextLimitLabel.text = "\(user.bio?.count ?? 0) / 150"
        bioTextLimitLabel.textAlignment = .right
        bioTextLimitLabel.font = .systemFont(ofSize: 10)
        bioTextLimitLabel.textColor = .mediumGray
        view.addSubview(bioTextLimitLabel)

        bioTextView.text = user.bio
        bioTextView.delegate = self
        bioTextView.sizeToFit()
        bioTextView.isScrollEnabled = false
        bioTextView.returnKeyType = .done
        bioTextView.textContainerInset = .zero
        bioTextView.textContainer.lineFragmentPadding = 0
        bioTextView.font = .systemFont(ofSize: 14)
        bioTextView.textColor = .black
        bioTextView.layer.backgroundColor = UIColor.offWhite.cgColor
        bioTextView.layer.masksToBounds = false
        bioTextView.layer.shadowColor = UIColor.mediumGray.cgColor
        bioTextView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bioTextView.layer.shadowOpacity = 1.0
        bioTextView.layer.shadowRadius = 0.0
        view.addSubview(bioTextView)

        accountInfoTitleLabel.text = "Linked Accounts and Information"
        accountInfoTitleLabel.font = .systemFont(ofSize: 16)
        accountInfoTitleLabel.textColor = .black
        view.addSubview(accountInfoTitleLabel)

        accountInfoDescriptionLabel.text = "Linked Accounts allow you to find friends you know but won't post to other accounts."
        accountInfoDescriptionLabel.textColor = .mediumGray
        accountInfoDescriptionLabel.font = .systemFont(ofSize: 10)
        accountInfoDescriptionLabel.numberOfLines = 0
        view.addSubview(accountInfoDescriptionLabel)

        linkedAccountFieldLabel.text = user.socialIdTokenType?.capitalized
        linkedAccountFieldLabel.font = .systemFont(ofSize: 10)
        linkedAccountFieldLabel.textColor = .mediumGray
        view.addSubview(linkedAccountFieldLabel)

        linkedAccountLabel.text = user.name
        linkedAccountLabel.font = .systemFont(ofSize: 12)
        linkedAccountLabel.textColor = .black
        view.addSubview(linkedAccountLabel)

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)

        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.gradientPurple, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 14)
        saveButton.addTarget(self, action: #selector(saveProfileInformation), for: .touchUpInside)

        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.layer.shadowOpacity = 0.0
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .movieWhite
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.07
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationController?.navigationBar.layer.shadowRadius = 8
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)

        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    private func setupConstraints() {
        let editButtonSize = CGSize(width: 30, height: 30)
        let horizontalPadding = 24
        let profileImageSize = CGSize(width: 100, height: 100)
        let smallFieldSize = CGSize(width: 152, height: 17)
        let verticalPadding = 30

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(profileImageSize)
        }

        selectImageButton.snp.makeConstraints { make in
            make.size.equalTo(editButtonSize)
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(horizontalPadding/2)
        }

        nameFieldLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameFieldLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(nameFieldLabel)
            make.height.equalTo(smallFieldSize.height)
        }

        userNameFieldLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameFieldLabel)
            make.top.equalTo(nameTextField.snp.bottom).offset(verticalPadding)
        }

        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameFieldLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(userNameFieldLabel)
            make.height.equalTo(smallFieldSize.height)
        }

        bioFieldLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(verticalPadding)
            make.leading.equalTo(nameFieldLabel)
            make.trailing.equalTo(bioTextLimitLabel.snp.leading)
        }

        bioTextLimitLabel.snp.makeConstraints { make in
            make.trailing.equalTo(nameFieldLabel)
            make.top.equalTo(bioFieldLabel)
            make.width.equalTo(45)
        }

        bioTextView.snp.makeConstraints { make in
            make.top.equalTo(bioFieldLabel.snp.bottom).offset(4)
            make.leading.equalTo(bioFieldLabel)
            make.trailing.equalTo(bioTextLimitLabel)
        }

        accountInfoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bioTextView.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
        }

        accountInfoDescriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(accountInfoTitleLabel)
            make.top.equalTo(accountInfoTitleLabel.snp.bottom).offset(6)
        }

        linkedAccountFieldLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(accountInfoTitleLabel)
            make.top.equalTo(accountInfoDescriptionLabel.snp.bottom).offset(verticalPadding)
        }

        linkedAccountLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(accountInfoTitleLabel)
            make.top.equalTo(linkedAccountFieldLabel.snp.bottom).offset(4)
        }

        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
        }

        saveButton.snp.makeConstraints { make in
            make.size.equalTo(saveButtonSize)
        }

    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func selectImage() {
        let galleryPhotoAction = UIAlertAction(title: "Choose from gallery", style: .default) { _ in self.selectFromGallery() }
        let takePhotoAction = UIAlertAction(title: "Take new photo", style: .default) { _ in self.takeNewPhoto() }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let alert = UIAlertController(title: "Upload profile photo", message: nil, preferredStyle: .actionSheet)

        alert.addAction(galleryPhotoAction)
        alert.addAction(takePhotoAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    @objc func saveProfileInformation() {
        // If username changed, check if username exists before updating user information
        if let username = userNameTextField.text, username != user.username {
            NetworkManager.checkUsernameNotExists(username: username) { [weak self] success in
                guard let self = self else { return }
                if success {
                    // Username does not yet exists so we can update user info
                    self.updateUserInfo()
                } else {
                    self.stopNavBarSpinner()
                    let banner = StatusBarNotificationBanner(
                        title: "Username invalid or already taken",
                        style: .warning
                    )
                    banner.show()

                }
            }
        } else {
            self.updateUserInfo()
        }
    }

    private func updateUserInfo() {
        if let name = nameTextField.text,
            let username = userNameTextField.text,
            let bio = bioTextView.text {
            // Only update profilePic if it's changed
            let base64ProfileImage = didChangeProfilePic ?
                "data:image/png;base64, \(profileImageView.image?.pngData()?.base64EncodedString() ?? "")" :
                nil
            let updatedUser = User(
                username: username,
                name: name,
                bio: bio,
                profilePic: base64ProfileImage,
                phoneNumber: user.phoneNumber,
                socialIdToken: user.socialIdToken,
                socialIdTokenType: user.socialIdTokenType
            )
            startNavBarSpinner()
            NetworkManager.updateUserProfile(user: updatedUser) { [ weak self] user in
                guard let self = self else { return }
                self.user = user
                self.delegate?.updateUser(user: user)
                if self.didChangeProfilePic {
                    ImageCache.default.removeImage(forKey: "userid-\(user.id)")
                }
                DispatchQueue.main.async {
                    self.stopNavBarSpinner()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    private func startNavBarSpinner() {
        let barButton = UIBarButtonItem(customView: spinner)
        navigationItem.rightBarButtonItem = barButton
        spinner.startAnimating()
    }

    private func stopNavBarSpinner() {
        spinner.stopAnimating()
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    private func selectFromGallery() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    private func takeNewPhoto() {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }

}

extension EditProfileViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        let currentText = textView.text ?? ""
        let updatedTextCount = currentText.count + text.count - range.length
        bioTextLimitLabel.text = "\(updatedTextCount) / 150"
        return updatedTextCount < 150
    }

}

extension EditProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            setProfilePic(with: image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            setProfilePic(with: image)
        }
        dismiss(animated: true, completion: nil)
    }

    func setProfilePic(with image: UIImage) {
        let resizedImage = image.resize(toSize: profileImageSize)
        profileImageView.image = resizedImage
        didChangeProfilePic = true
    }
}

extension EditProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
