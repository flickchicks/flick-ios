//
//  ListViewController.swift
//  Flick
//
//  Created by HAIYING WENG on 5/23/20.
//  Copyright © 2020 flick. All rights reserved.
//

import SnapKit
import UIKit

class ListViewController: UIViewController {

    // MARK: - Private View Vars
    private let addButton = UIButton()
    private let listNameLabel = UILabel()
    private var mediaCollectionView: UICollectionView!
    private let mediaContainerView = UIView()
    private let sortButton = UIButton()

    // MARK: - Private Data Vars
    private let buttonSize = CGSize(width: 44, height: 44)
    private let mediaCellReuseIdentifiter = "MediaCellReuseIdentifier"

    // Temp values
    private let listName = "Saved"
    private let media = ["", "", "", "", "", "", "", "", "", "", "", "", ""]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightPurple

        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = .lightPurple
        navigationController?.navigationBar.shadowImage = UIImage()

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 22, height: 18))
        }
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        listNameLabel.text = listName
        listNameLabel.font = .boldSystemFont(ofSize: 20)
        view.addSubview(listNameLabel)

        mediaContainerView.backgroundColor = .white
        mediaContainerView.clipsToBounds = false
        mediaContainerView.layer.cornerRadius = 50
        mediaContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mediaContainerView.layer.shadowColor = UIColor.black.cgColor
        mediaContainerView.layer.shadowOffset = CGSize(width: 0, height: -4)
        mediaContainerView.layer.shadowOpacity = 0.1
        mediaContainerView.layer.shadowRadius = 8
        view.addSubview(mediaContainerView)

        let mediaCollectionViewLayout = UICollectionViewFlowLayout()
        mediaCollectionViewLayout.minimumInteritemSpacing = 20
        mediaCollectionViewLayout.minimumLineSpacing = 20
        mediaCollectionViewLayout.scrollDirection = .vertical

        mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mediaCollectionViewLayout)
        mediaCollectionView.backgroundColor = .white
        mediaCollectionView.register(MediaInListCollectionViewCell.self, forCellWithReuseIdentifier: mediaCellReuseIdentifiter)
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
        mediaCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(mediaCollectionView)

        addButton.setImage(UIImage(named: "addButton"), for: .normal)
        addButton.layer.cornerRadius = buttonSize.width / 2
        view.addSubview(addButton)

        sortButton.setImage(UIImage(named: "sortButton"), for: .normal)
        sortButton.layer.cornerRadius = buttonSize.width / 2
        view.addSubview(sortButton)

        setupConstraints()
    }

    private func setupConstraints() {
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(mediaContainerView.snp.top)
            make.trailing.equalTo(mediaContainerView.snp.trailing).offset(-40)
            make.size.equalTo(buttonSize)
        }

        listNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(36)
        }

        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mediaContainerView.snp.top).offset(46)
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalTo(mediaContainerView.snp.bottom)
        }

        mediaContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200) //200 is temp
            make.leading.trailing.bottom.equalToSuperview()
        }

        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(mediaContainerView.snp.top)
            make.trailing.equalTo(addButton.snp.leading).offset(-20)
            make.size.equalTo(buttonSize)
        }
    }

    @objc private func backButtonPressed() {
        print("Back button pressed")
    }

}

extension ListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifiter, for: indexPath) as? MediaInListCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }

}

extension ListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (mediaCollectionView.frame.width - 2 * 20) / 3.0
        let height = width * 3 / 2
        return CGSize(width: width, height: height)
    }

}
