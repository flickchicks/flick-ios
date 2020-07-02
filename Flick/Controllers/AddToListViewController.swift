//
//  AddToListViewController.swift
//  Flick
//
//  Created by Haiying W on 6/27/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

// TODO: need to be able to pull down to dismiss
class AddToListViewController: UIViewController {

    // MARK: - Private View Vars
    private let addToListLabel = UILabel()
    private let doneButton = UIButton()
    private let selectedLabel = UILabel()
    private let resultLabel = UILabel()
    private var suggestedMediaCollectionView: UICollectionView!
    private var resultMediaTableView = UITableView()
    private let roundTopView = RoundTopView(hasShadow: true)

    // MARK: - Private Data Vars
    private var height: Float!
    private let suggestedMediaCellPadding: CGFloat = 20
    private let doneButtonSize = CGSize(width: 44, height: 44)
    private let mediaSearchCellReuseIdentifier = "MediaSearchResultCellReuseIdentifier"
    private let mediaSelectableCellReuseIdentifier = "MediaSelectableCellReuseIdentifier"

    private var numSearchResultMedia = 0
    private var numSelected = 0
    // TODO: Get result from backend. Media are string for now
    private var selectedMedia = [String]()
    private var searchResultMedia = ["", "", "", "", "", "", "", "", "", "", "", ""]
    private var suggestedMedia = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]

    init(height: Float) {
        super.init(nibName: nil, bundle: nil)

        self.height = height
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        view.addSubview(roundTopView)

        addToListLabel.text = "Add to List"
        addToListLabel.textColor = .darkBlue
        addToListLabel.font = .systemFont(ofSize: 18, weight: .medium)
        view.addSubview(addToListLabel)

        doneButton.setImage(UIImage(named: "doneButton"), for: .normal)
        doneButton.layer.cornerRadius = doneButtonSize.width / 2
        doneButton.addTarget(self, action: #selector(tappedDone), for: .touchUpInside)
        view.addSubview(doneButton)

        selectedLabel.text = "0 Selected"
        selectedLabel.textColor = .darkBlueGray2
        selectedLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(selectedLabel)

        resultLabel.text = "Suggested"
        resultLabel.textColor = .darkBlueGray2
        resultLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(resultLabel)

        resultMediaTableView.isHidden = true
        resultMediaTableView.delegate = self
        resultMediaTableView.dataSource = self
        resultMediaTableView.register(MediaSearchResultTableViewCell.self, forCellReuseIdentifier: mediaSearchCellReuseIdentifier)
        resultMediaTableView.separatorStyle = .none
        resultMediaTableView.allowsMultipleSelection = true
        resultMediaTableView.bounces = false
        resultMediaTableView.showsVerticalScrollIndicator = false
        view.addSubview(resultMediaTableView)

        let mediaCollectionViewLayout = UICollectionViewFlowLayout()
        mediaCollectionViewLayout.minimumInteritemSpacing = suggestedMediaCellPadding
        mediaCollectionViewLayout.minimumLineSpacing = suggestedMediaCellPadding
        mediaCollectionViewLayout.scrollDirection = .vertical

        suggestedMediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mediaCollectionViewLayout)
        suggestedMediaCollectionView.backgroundColor = .white
        suggestedMediaCollectionView.register(MediaSelectableCollectionViewCell.self, forCellWithReuseIdentifier: mediaSelectableCellReuseIdentifier)
        suggestedMediaCollectionView.dataSource = self
        suggestedMediaCollectionView.delegate = self
        suggestedMediaCollectionView.showsVerticalScrollIndicator = false
        suggestedMediaCollectionView.bounces = false
        suggestedMediaCollectionView.allowsMultipleSelection = true
        view.addSubview(suggestedMediaCollectionView)

        setupConstraints()
    }

    private func setupConstraints() {
        addToListLabel.snp.makeConstraints { make in
            make.top.equalTo(roundTopView).offset(30)
            make.leading.equalToSuperview().offset(36)
            make.trailing.equalToSuperview()
        }

        roundTopView.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundTopView.snp.top)
            make.trailing.equalTo(roundTopView.snp.trailing).inset(40)
            make.size.equalTo(doneButtonSize)
        }

        selectedLabel.snp.makeConstraints { make in
            make.top.equalTo(addToListLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(36)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(36)
        }

        resultMediaTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(resultLabel.snp.bottom).offset(14)
            make.bottom.equalToSuperview()
        }

        suggestedMediaCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(resultLabel.snp.bottom).offset(14)
            make.bottom.equalToSuperview()
        }
    }

    @objc private func tappedDone() {
        dismiss(animated: true, completion: nil)
    }

}

extension AddToListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultMedia.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: mediaSearchCellReuseIdentifier, for: indexPath) as? MediaSearchResultTableViewCell else { return UITableViewCell() }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        numSelected += 1
        selectedLabel.text = "\(numSelected) Selected"
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        numSelected -= 1
        selectedLabel.text = "\(numSelected) Selected"
    }

}

extension AddToListViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestedMedia.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaSelectableCellReuseIdentifier, for: indexPath) as? MediaSelectableCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        numSelected += 1
        selectedLabel.text = "\(numSelected) Selected"
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        numSelected -= 1
        selectedLabel.text = "\(numSelected) Selected"
    }

}

extension AddToListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = suggestedMediaCollectionView.frame.width / 3.0 - suggestedMediaCellPadding
        let height = width * 3 / 2
        return CGSize(width: width, height: height)
    }

}
