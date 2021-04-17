//
//  SaveToListTableViewCell.swift
//  Telie
//
//  Created by Lucy Xu on 3/30/21.
//  Copyright © 2021 Telie. All rights reserved.
//

import UIKit

class SaveToListTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let listInfoStackView = UIStackView()
    private let iconImageView = UIImageView()
    private var mediaCollectionView: UICollectionView!
//    private let selectView = UIView()
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private var list: SimpleMediaList!
    private var index: Int?
    private var media: [SimpleMedia] = []
    private let mediaCellReuseIdentifier = "MediaCellReuseIdentifier"

    weak var delegate: SaveMediaDelegate?

    static let reuseIdentifier = "SaveToListTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        isUserInteractionEnabled = true
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .lightGray2
        contentView.addSubview(containerView)

        listInfoStackView.axis = .horizontal
        listInfoStackView.alignment = .center
        listInfoStackView.spacing = 8
        contentView.addSubview(listInfoStackView)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 16, height: 14))
        }
        listInfoStackView.addArrangedSubview(iconImageView)

        titleLabel.linesCornerRadius = 6
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 14)
        listInfoStackView.addArrangedSubview(titleLabel)

//        selectView.layer.borderWidth = 2
//        selectView.layer.cornerRadius = 3
//        contentView.addSubview(selectView)

        let mediaLayout = UICollectionViewFlowLayout()
        mediaLayout.minimumInteritemSpacing = 12
        mediaLayout.scrollDirection = .horizontal

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(saveMedia))
        mediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: mediaLayout)
        mediaCollectionView.register(MediaInListCollectionViewCell.self, forCellWithReuseIdentifier: mediaCellReuseIdentifier)
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.contentInset = UIEdgeInsets(top: 0, left: 34, bottom: 0, right: 16)
        mediaCollectionView.backgroundColor = .clear
        mediaCollectionView.showsHorizontalScrollIndicator = false
        mediaCollectionView.isScrollEnabled = false
        mediaCollectionView.allowsSelection = false
        mediaCollectionView.addGestureRecognizer(tapGestureRecognizer)
        contentView.addSubview(mediaCollectionView)

        setupConstraints()
    }

    private func setupConstraints() {
        let padding = 12

        mediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(padding)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(containerView).inset(padding)
            make.height.equalTo(120)
        }

        listInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(padding)
            make.leading.equalToSuperview().offset(34)
            make.trailing.equalTo(containerView).inset(padding)
            make.height.equalTo(20)
        }

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

    }

    func configure(
        for list: SimpleMediaList,
        isSelected: Bool = false,
        index: Int = 0, // filler value for now
        delegate: SaveMediaDelegate
    ) {
        self.index = index
        self.list = list
        self.media = Array(list.shows.prefix(4))
        self.delegate = delegate
        titleLabel.text = list.name
        if list.collaborators.count > 0 {
            iconImageView.isHidden = false
            iconImageView.image = UIImage(named: "peopleIcon")
        } else if list.isPrivate {
            iconImageView.isHidden = false
            iconImageView.image = UIImage(named: "lock")
        } else {
            iconImageView.isHidden = true
        }
        containerView.isHidden = !isSelected
//        selectView.layer.borderColor =
//            isSelected ?
//            UIColor.gradientPurple.cgColor :
//            UIColor.lightGray.cgColor
        mediaCollectionView.reloadData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func saveMedia() {
        guard let index = index else { return }
        delegate?.selectMedia(selectedIndex: index)
    }

}

extension SaveToListTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // If list is empty, show 4 filler cells
        if media.isEmpty {
            return 4
        } else {
            return media.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaCellReuseIdentifier, for: indexPath) as? MediaInListCollectionViewCell else { return UICollectionViewCell() }
        if media.count != 0 {
            let media = self.media[indexPath.row]
            cell.configure(media: media)
        }
        return cell
    }
}

extension SaveToListTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
}
