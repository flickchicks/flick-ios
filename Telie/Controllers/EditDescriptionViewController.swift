//
//  EditDescriptionViewController.swift
//  Telie
//
//  Created by Haiying W on 5/20/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

class EditDescriptionViewController: UIViewController {

    // MARK: - Private Data Vars
    private var list: MediaList

    // MARK: - Private View Vars
    private let descriptionTextView = UITextView()
    private let saveButton = UIButton()
    private let spinner = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 20, height: 20),
        type: .lineSpinFadeLoader,
        color: .gradientPurple
    )
    private let titleLabel = UILabel()

    init(list: MediaList) {
        self.list = list
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        descriptionTextView.text = list.description
        descriptionTextView.delegate = self
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.returnKeyType = .done
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.font = .systemFont(ofSize: 14)
        descriptionTextView.textColor = .black
        descriptionTextView.layer.masksToBounds = false
        descriptionTextView.layer.shadowColor = UIColor.mediumGray.cgColor
        descriptionTextView.layer.shadowOffset = CGSize(width: 0, height: 1)
        descriptionTextView.layer.shadowOpacity = 1.0
        descriptionTextView.layer.shadowRadius = 0.0
        view.addSubview(descriptionTextView)

        titleLabel.text = "Edit Description"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        view.addSubview(titleLabel)

        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.gradientPurple, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 14)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)

        view.addSubview(spinner)

        setupConstraints()
    }

    private func setupConstraints() {
        let horizontalPadding = 24
        let titleLabelSize = CGSize(width: 144, height: 22)
        let verticalPadding = 36

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalPadding)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
            make.size.equalTo(titleLabelSize)
        }

        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(horizontalPadding)
        }

        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(4)
            make.size.equalTo(CGSize(width: 66, height: 34))
        }

        spinner.snp.makeConstraints { make in
            make.center.equalTo(saveButton)
        }
    }

    @objc private func saveTapped() {
        guard let descriptionText = descriptionTextView.text,
              descriptionText.trimmingCharacters(in: .whitespaces) != "" else { return }
        spinner.startAnimating()
        saveButton.isHidden = true
        list.description = descriptionText
        NetworkManager.updateMediaList(listId: list.id, list: list) { [weak self] list in
            guard let self = self else { return }
            self.spinner.stopAnimating()
            self.saveButton.isHidden = false
        }
    }

}

extension EditDescriptionViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        let currentText = textView.text ?? ""
        let updatedTextCount = currentText.count + text.count - range.length
        return updatedTextCount < 150
    }

}
