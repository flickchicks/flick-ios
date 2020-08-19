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
    private let chevronButton = UIButton()
    private let doneButton = UIButton()
    private let searchBar = SearchBar()
    private let selectedLabel = UILabel()
    private var selectedMediaCollectionView: UICollectionView!
    private var suggestedMediaCollectionView: UICollectionView!
    private let resultLabel = UILabel()
    private var resultMediaTableView = UITableView()
    private let roundTopView = RoundTopView(hasShadow: true)

    // MARK: - Private Data Vars
    private var collectionViewCellSize = CGSize(width: 0, height: 0)
    private let doneButtonSize = CGSize(width: 44, height: 44)
    private var height: Float!
    private let mediaCellPadding: CGFloat = 20
    private let tableHorizontalOffset = 24

    private let mediaSearchCellReuseIdentifier = "MediaSearchResultCellReuseIdentifier"
    private let mediaSelectableCellReuseIdentifier = "MediaSelectableCellReuseIdentifier"
    private let selectedMediaCellReuseIdentifier = "SelectedMediaCellReuseIdentifier"

    private var isSearching = false
    private var isSelectedHidden = true
    private var list: MediaList
    // TODO: Get result from backend. Media are string for now
    private var searchResultMedia: [Media] = []
    private var selectedMedia: [SimpleMedia] = []
    private var suggestedMedia = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]

    init(height: Float, list: MediaList) {
        self.list = list
        self.height = height
        super.init(nibName: nil, bundle: nil)
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

        chevronButton.setImage(UIImage(named: "downChevron"), for: .normal)
        chevronButton.addTarget(self, action: #selector(tappedChevron), for: .touchUpInside)
        view.addSubview(chevronButton)

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

        let suggestedMediaCollectionViewLayout = UICollectionViewFlowLayout()
        suggestedMediaCollectionViewLayout.minimumInteritemSpacing = mediaCellPadding
        suggestedMediaCollectionViewLayout.minimumLineSpacing = mediaCellPadding
        suggestedMediaCollectionViewLayout.scrollDirection = .vertical

        suggestedMediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: suggestedMediaCollectionViewLayout)
        suggestedMediaCollectionView.backgroundColor = .white
        suggestedMediaCollectionView.register(MediaSelectableCollectionViewCell.self, forCellWithReuseIdentifier: mediaSelectableCellReuseIdentifier)
        suggestedMediaCollectionView.dataSource = self
        suggestedMediaCollectionView.delegate = self
        suggestedMediaCollectionView.showsVerticalScrollIndicator = false
        suggestedMediaCollectionView.bounces = false
        suggestedMediaCollectionView.allowsMultipleSelection = true
        view.addSubview(suggestedMediaCollectionView)

        let selectedMediaCollectionViewLayout = UICollectionViewFlowLayout()
        selectedMediaCollectionViewLayout.minimumInteritemSpacing = mediaCellPadding
        selectedMediaCollectionViewLayout.minimumLineSpacing = mediaCellPadding
        selectedMediaCollectionViewLayout.scrollDirection = .horizontal
        selectedMediaCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 36, bottom: 0, right: 0)

        selectedMediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: selectedMediaCollectionViewLayout)
        selectedMediaCollectionView.isHidden = true
        selectedMediaCollectionView.backgroundColor = .white
        selectedMediaCollectionView.register(MediaSelectableCollectionViewCell.self, forCellWithReuseIdentifier: selectedMediaCellReuseIdentifier)
        selectedMediaCollectionView.dataSource = self
        selectedMediaCollectionView.delegate = self
        selectedMediaCollectionView.showsHorizontalScrollIndicator = false
        selectedMediaCollectionView.bounces = false
        selectedMediaCollectionView.allowsMultipleSelection = true
        view.addSubview(selectedMediaCollectionView)

        searchBar.placeholder = "Search movies and shows"
        searchBar.delegate = self
        view.addSubview(searchBar)

        getCellSize()
        setupConstraints()
    }

    private func getCellSize() {
        let width = (view.frame.width - CGFloat(2 * tableHorizontalOffset)) / 3.0  - mediaCellPadding
        let height = width * 3 / 2
        collectionViewCellSize = CGSize(width: width, height: height)
    }

    private func setupConstraints() {
        let chevronSize = CGSize(width: 15, height: 7)
        let labelLeadingOffset = 36
        let verticalOffset = 20

        addToListLabel.snp.makeConstraints { make in
            make.top.equalTo(roundTopView).offset(30)
            make.leading.equalToSuperview().offset(labelLeadingOffset)
            make.trailing.equalToSuperview()
        }

        roundTopView.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.leading.trailing.bottom.equalToSuperview()
        }

        doneButton.snp.makeConstraints { make in
            make.centerY.equalTo(roundTopView.snp.top)
            make.trailing.equalTo(roundTopView.snp.trailing).inset(40)
            make.size.equalTo(doneButtonSize)
        }

        selectedLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(verticalOffset)
            make.leading.equalToSuperview().offset(labelLeadingOffset)
        }

        chevronButton.snp.makeConstraints { make in
            make.size.equalTo(chevronSize)
            make.centerY.equalTo(selectedLabel.snp.centerY)
            make.leading.equalTo(selectedLabel.snp.trailing).offset(8)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedLabel.snp.bottom).offset(verticalOffset)
            make.leading.equalToSuperview().offset(labelLeadingOffset)
        }

        resultMediaTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(tableHorizontalOffset)
            make.top.equalTo(resultLabel.snp.bottom).offset(verticalOffset)
            make.bottom.equalToSuperview()
        }

        suggestedMediaCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(tableHorizontalOffset)
            make.top.equalTo(resultLabel.snp.bottom).offset(verticalOffset)
            make.bottom.equalToSuperview()
        }

        selectedMediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedLabel.snp.bottom).offset(15)
            make.height.equalTo(collectionViewCellSize.height + 10)
            make.leading.trailing.equalToSuperview()
        }

        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(labelLeadingOffset)
            make.top.equalTo(addToListLabel.snp.bottom).offset(12)
            make.height.equalTo(36)
        }
    }

    private func showSelectedMedia() {
        selectedMediaCollectionView.isHidden = isSelectedHidden
        if isSelectedHidden {
            resultLabel.snp.remakeConstraints { remake in
                remake.top.equalTo(selectedLabel.snp.bottom).offset(24)
                remake.leading.equalToSuperview().offset(36)
            }
        } else {
            resultLabel.snp.remakeConstraints { remake in
                remake.top.equalTo(selectedMediaCollectionView.snp.bottom).offset(15)
                remake.leading.equalToSuperview().offset(36)
            }
        }
    }

    @objc private func tappedDone() {
        let mediaIds = selectedMedia.map { $0.id }
        NetworkManager.addToMediaList(listId: list.id, mediaIds: mediaIds) { [weak self] list in
            guard let self = self else { return }
            self.list = list
            self.selectedMedia = []
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc private func tappedChevron() {
        isSelectedHidden.toggle()
        chevronButton.setImage(UIImage(named: isSelectedHidden ? "downChevron" : "upChevron"), for: .normal)
        reloadSelectedMediaCollectionView()
        showSelectedMedia()
    }

    private func searchMediaByQuery(_ query: String) {
        NetworkManager.searchMedia(query: query) { [weak self] media in
            guard let self = self, self.isSearching else { return }
            self.searchResultMedia = media
            self.resultMediaTableView.reloadData()
        }
    }

    private func selectMedia(_ media: Media) {
        selectedMedia.append(SimpleMedia(id: media.id, posterPic: media.posterPic))
        selectedLabel.text = "\(selectedMedia.count) Selected"
        reloadSelectedMediaCollectionView()
    }

    private func deselectMedia(_ media: Media) {
        selectedMedia.removeAll { $0.id == media.id }
        selectedLabel.text = "\(selectedMedia.count) Selected"
        reloadSelectedMediaCollectionView()
    }

    private func reloadSelectedMediaCollectionView() {
        selectedMediaCollectionView.reloadData()
        for item in 0 ..< selectedMedia.count {
            let indexPath = IndexPath(item: item, section: 0)
            selectedMediaCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
        }
    }

}

extension AddToListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultMedia.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: mediaSearchCellReuseIdentifier, for: indexPath) as? MediaSearchResultTableViewCell else { return UITableViewCell() }
        cell.configure(media: searchResultMedia[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectMedia(searchResultMedia[indexPath.row])
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        deselectMedia(searchResultMedia[indexPath.row])
    }

}

extension AddToListViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == selectedMediaCollectionView ? selectedMedia.count : suggestedMedia.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == selectedMediaCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: selectedMediaCellReuseIdentifier, for: indexPath) as? MediaSelectableCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(media: selectedMedia[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaSelectableCellReuseIdentifier, for: indexPath) as? MediaSelectableCollectionViewCell else { return UICollectionViewCell() }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectMedia(searchResultMedia[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        deselectMedia(searchResultMedia[indexPath.row])
    }

}

extension AddToListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewCellSize
    }

}

extension AddToListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            resultLabel.text = "Suggested"
            resultMediaTableView.isHidden = true
            suggestedMediaCollectionView.isHidden = false
        } else {
            isSearching = true
            resultLabel.text = "\(searchResultMedia.count) Results"
            resultMediaTableView.isHidden = false
            suggestedMediaCollectionView.isHidden = true
            searchMediaByQuery(searchText)
        }
    }

}
