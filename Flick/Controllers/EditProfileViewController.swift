//
//  EditProfileViewController.swift
//  Flick
//
//  Created by Lucy Xu on 8/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileInputTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        font = .systemFont(ofSize: 14)
        textColor = .black
        borderStyle = .none
        layer.backgroundColor = UIColor.offWhite.cgColor
        layer.masksToBounds = false
        layer.shadowColor = UIColor.mediumGray.cgColor
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: frame.height))
        leftViewMode = .always
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

protocol EditProfileDelegate: class {
    func updateUser(user: UserProfile)
}

class EditProfileViewController: UIViewController {

    // MARK: - Private View Vars
    private let accountInfoDescriptionLabel = UILabel()
    private let accountInfoTitleLabel = UILabel()
    private let bioFieldLabel = UILabel()
    private let bioTextView = UITextView()
    private let bioTextLimitLabel = UILabel()
    private let editProfileTitleLabel = UILabel()
    private let facebookAccountLabel = UILabel()
    private let facebookFieldLabel = UILabel()
    private let headerView = UIView()
    private let imagePickerController = UIImagePickerController()
    private let nameFieldLabel = UILabel()
    private let nameTextField = ProfileInputTextField()
    private let profileImageView = UIImageView()
    private let profileSelectionModalView = ProfileSelectionModalView()
    private let selectImageButton = UIButton()
    private let userNameFieldLabel = UILabel()
    private let userNameTextField = ProfileInputTextField()

    // MARK: - Private Data Vars
    weak var delegate: EditProfileDelegate?
    private var didChangeProfilePic = false
    private let profileImageSize = CGSize(width: 50, height: 50)
    private var user: UserProfile

    init(user: UserProfile) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .offWhite
        setupNavigationBar()

        profileSelectionModalView.modalDelegate = self
        profileSelectionModalView.profileSelectionDelegate = self

        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false
        imagePickerController.mediaTypes = ["public.image"]

        if let profilePic = user.profilePic {
            profileImageView.kf.setImage(with: Base64ImageDataProvider(base64String: profilePic, cacheKey: "userid-\(user.id)"))
        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.backgroundColor = UIColor.lightGray.cgColor
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

        // TODO: Change this to one single name field later?
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

        bioTextLimitLabel.text = "0 / 150"
        bioTextLimitLabel.textAlignment = .right
        bioTextLimitLabel.font = .systemFont(ofSize: 10)
        bioTextLimitLabel.textColor = .mediumGray
        view.addSubview(bioTextLimitLabel)

        bioTextView.text = user.bio
        bioTextView.delegate = self
        bioTextView.sizeToFit()
        bioTextView.isScrollEnabled = false
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
//        view.addSubview(accountInfoTitleLabel)

        accountInfoDescriptionLabel.text = "Linked Accounts allow you to find friends you know but won't post to other accounts."
        accountInfoDescriptionLabel.textColor = .mediumGray
        accountInfoDescriptionLabel.font = .systemFont(ofSize: 10)
        accountInfoDescriptionLabel.numberOfLines = 0
//        view.addSubview(accountInfoDescriptionLabel)

        facebookFieldLabel.text = "Facebook"
        facebookFieldLabel.font = .systemFont(ofSize: 10)
        facebookFieldLabel.textColor = .mediumGray
//        view.addSubview(facebookFieldLabel)

        facebookAccountLabel.text = "Alanna Zhou"
        facebookAccountLabel.font = .systemFont(ofSize: 12)
        facebookAccountLabel.textColor = .black
//        view.addSubview(facebookAccountLabel)

        setupConstraints()
    }

    private func setupNavigationBar() {
        let backButtonSize = CGSize(width: 22, height: 18)
        // TODO: Update save button size
        let saveButtonSize = CGSize(width: 33, height: 17)

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

        editProfileTitleLabel.text = "Edit Profile"
        editProfileTitleLabel.font = .systemFont(ofSize: 18)
        editProfileTitleLabel.textColor = .black
        navigationController?.navigationBar.addSubview(editProfileTitleLabel)

        editProfileTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(59)
            make.top.bottom.trailing.equalToSuperview()
        }

        let saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.gradientPurple, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 14)
        saveButton.snp.makeConstraints { make in
            make.size.equalTo(saveButtonSize)
        }

        saveButton.addTarget(self, action: #selector(saveProfileInformation), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButtonItem

        headerView.backgroundColor = .movieWhite
        headerView.clipsToBounds = false
        headerView.layer.masksToBounds = false
        headerView.layer.shadowColor = UIColor.blueGrayShadow.cgColor
        headerView.layer.shadowOpacity = 0.07
        headerView.layer.shadowOffset = .init(width: 0, height: 4)
        headerView.layer.shadowRadius = 8
        view.addSubview(headerView)

        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(10)
        }

    }

    private func setupConstraints() {
        let editButtonSize = CGSize(width: 30, height: 30)
        let horizontalPadding = 24
        let profileImageSize = CGSize(width: 100, height: 100)
        let smallFieldSize = CGSize(width: 152, height: 17)
        let verticalPadding = 30

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(24)
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

//        accountInfoTitleLabel.snp.makeConstraints { make in
//            make.top.equalTo(bioTextView.snp.bottom).offset(36)
//            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
//        }
//
//        accountInfoDescriptionLabel.snp.makeConstraints { make in
//            make.leading.trailing.equalTo(accountInfoTitleLabel)
//            make.top.equalTo(accountInfoTitleLabel.snp.bottom).offset(6)
//        }
//
//        facebookFieldLabel.snp.makeConstraints { make in
//            make.leading.trailing.equalTo(accountInfoTitleLabel)
//            make.top.equalTo(accountInfoDescriptionLabel.snp.bottom).offset(verticalPadding)
//        }
//
//        facebookAccountLabel.snp.makeConstraints { make in
//            make.leading.trailing.equalTo(accountInfoTitleLabel)
//            make.top.equalTo(facebookFieldLabel.snp.bottom).offset(4)
//        }

    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }

    @objc func selectImage() {
        // TODO: Revisit if having multiple scenes becomes an issue (for ex. with iPad)
        showModalPopup(view: profileSelectionModalView)
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
                    self.presentInfoAlert(message: "Username invalid or already taken", completion: nil)
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
            let base64ProfileImage = didChangeProfilePic ? profileImageView.image?.pngData()?.base64EncodedString() : nil
            let updatedUser = User(username: username, name: name, bio: bio, profilePic: base64ProfileImage, phoneNumber: user.phoneNumber, socialIdToken: user.socialIdToken, socialIdTokenType: user.socialIdTokenType)
            NetworkManager.updateUserProfile(user: updatedUser) { [ weak self] user in
                guard let self = self else { return }
                self.user = user
                self.presentInfoAlert(message: "Profile updated", completion: nil)
                self.delegate?.updateUser(user: user)
                if self.didChangeProfilePic {
                    ImageCache.default.removeImage(forKey: "userid-\(user.id)")
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        editProfileTitleLabel.removeFromSuperview()
    }

}

extension EditProfileViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        // Attempt to read the range they are trying to change, or terminate if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // Add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        let charCount = updatedText.count
        bioTextLimitLabel.text = "\(charCount) / 150"
        return charCount <= 150
    }

}

extension EditProfileViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let resizedImage = image.resize(toSize: profileImageSize, scale: UIScreen.main.scale)
        profileImageView.image = resizedImage
        profileSelectionModalView.removeFromSuperview()
        didChangeProfilePic = true
//        print(resizedImage.pngData()?.base64EncodedString())
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: ModalDelegate, ProfileSelectionDelegate {

    func dismissModal(modalView: UIView) {
        modalView.removeFromSuperview()
    }

    func selectFromGallery() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    func takeNewPhoto() {
        profileSelectionModalView.removeFromSuperview()
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }

}

extension EditProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
