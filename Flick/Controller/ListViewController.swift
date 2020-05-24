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
    
    private let addButton = UIButton()
    private let listNameLabel = UILabel()
    private var mediaCollectionView: UICollectionView!
    private let sortButton = UIButton()
    
    private let listName = "Saved"
    private let buttonSize = CGSize(width: 44, height: 44)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.968, green: 0.961, blue: 0.996, alpha: 1)
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.968, green: 0.961, blue: 0.996, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.titleTextAttributes = [
//            .font: UIFont.getFont(.medium, size: 24)
//        ]

        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 25, height: 20))
        }
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        listNameLabel.text = listName
        listNameLabel.font = .boldSystemFont(ofSize: 20)
        view.addSubview(listNameLabel)
        
        let mediaCollectionViewLayout = UICollectionViewLayout()
        
        mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mediaCollectionViewLayout)
        mediaCollectionView.backgroundColor = .white
        mediaCollectionView.clipsToBounds = false
        mediaCollectionView.layer.cornerRadius = 50
        mediaCollectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mediaCollectionView.layer.shadowColor = UIColor.black.cgColor
        mediaCollectionView.layer.shadowOffset = CGSize(width: 0, height: -4)
        mediaCollectionView.layer.shadowOpacity = 0.1
        mediaCollectionView.layer.shadowRadius = 8
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
            make.centerY.equalTo(mediaCollectionView.snp.top)
            make.trailing.equalTo(mediaCollectionView.snp.trailing).offset(-40)
            make.size.equalTo(buttonSize)
        }
        
        listNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(36)
        }
        
        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        sortButton.snp.makeConstraints { make in
            make.centerY.equalTo(mediaCollectionView.snp.top)
            make.trailing.equalTo(addButton.snp.leading).offset(-20)
            make.size.equalTo(buttonSize)
        }
    }
    
    @objc private func backButtonPressed() {
        
    }
    
}
