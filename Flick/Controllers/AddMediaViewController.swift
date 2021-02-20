//
//  AddMediaViewController.swift
//  Flick
//
//  Created by Haiying W on 6/27/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

enum AddMediaType {
    case toGroup, toList

    var title: String {
        switch self {
        case .toGroup:
            return "Add Ideas"
        case .toList:
            return "Add to List"
        }
    }
}

protocol AddMediaDelegate: class {
    func addMediaDismissed()
    func reloadMedia()
}

class AddMediaViewController: UIViewController {

    // MARK: - Private View Vars
    private let titleLabel = UILabel()
    private let backButton = UIButton()
    private let chevronButton = UIButton()
    private let doneButton = UIButton()
    private let quickAddButton = UIButton()
    private let searchBar = SearchBar()
    private let selectedLabel = UILabel()
    private var selectedMediaCollectionView: UICollectionView!
//    private var suggestedMediaCollectionView: UICollectionView!
    private let resultLabel = UILabel()
    private var resultMediaTableView = UITableView()
    private let roundTopView = RoundTopView(hasShadow: true)

    // MARK: - Private Data Vars
    private var collectionViewCellSize = CGSize(width: 0, height: 0)
    private let doneButtonSize = CGSize(width: 44, height: 44)
    private var height: Float
    private let mediaCellPadding: CGFloat = 20
    private let tableHorizontalOffset = 24

    private let mediaSearchCellReuseIdentifier = "MediaSearchResultCellReuseIdentifier"
    private let mediaSelectableCellReuseIdentifier = "MediaSelectableCellReuseIdentifier"
    private let selectedMediaCellReuseIdentifier = "SelectedMediaCellReuseIdentifier"

    private var groupId: Int?
    private var isSearching = false
    private var isSelectedHidden = true
    private var list: MediaList?
    private var searchResultMedia: [Media] = []
    private var selectedMedia: [SimpleMedia] = []
//    private var suggestedMedia = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    private var timer: Timer?
    private var type: AddMediaType

    // Keeps track of current position of pan gesture
    private var viewTranslation = CGPoint(x: 0, y: 0)

    weak var delegate: AddMediaDelegate?

    init(type: AddMediaType, height: Float, list: MediaList? = nil, groupId: Int? = nil) {
        self.type = type
        self.groupId = groupId
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

        titleLabel.text = type.title
        titleLabel.textColor = .darkBlue
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        view.addSubview(titleLabel)

        chevronButton.setImage(UIImage(named: "downChevron"), for: .normal)
        chevronButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
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
        resultMediaTableView.keyboardDismissMode = .onDrag
        view.addSubview(resultMediaTableView)

//        let suggestedMediaCollectionViewLayout = UICollectionViewFlowLayout()
//        suggestedMediaCollectionViewLayout.minimumInteritemSpacing = mediaCellPadding
//        suggestedMediaCollectionViewLayout.minimumLineSpacing = mediaCellPadding
//        suggestedMediaCollectionViewLayout.scrollDirection = .vertical
//
//        suggestedMediaCollectionView = UICollectionView(frame: .zero, collectionViewLayout: suggestedMediaCollectionViewLayout)
//        suggestedMediaCollectionView.backgroundColor = .white
//        suggestedMediaCollectionView.register(MediaSelectableCollectionViewCell.self, forCellWithReuseIdentifier: mediaSelectableCellReuseIdentifier)
//        suggestedMediaCollectionView.dataSource = self
//        suggestedMediaCollectionView.delegate = self
//        suggestedMediaCollectionView.showsVerticalScrollIndicator = false
//        suggestedMediaCollectionView.bounces = false
//        suggestedMediaCollectionView.allowsMultipleSelection = true
//        view.addSubview(suggestedMediaCollectionView)

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

        if type == .toGroup {
            quickAddButton.setTitle("Quick Add", for: .normal)
            quickAddButton.setTitleColor(.darkBlueGray2, for: .normal)
            quickAddButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            quickAddButton.backgroundColor = .lightGray2
            quickAddButton.titleEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
            quickAddButton.layer.cornerRadius = 12.5
            quickAddButton.layer.borderWidth = 1
            quickAddButton.layer.borderColor = UIColor.darkBlueGray2.cgColor
            quickAddButton.addTarget(self, action: #selector(quickAddTapped), for: .touchUpInside)
            view.addSubview(quickAddButton)
        }

        getCellSize()
        setupConstraints()

        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDragToDismiss)))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let backButtonSize = CGSize(width: 22, height: 18)

        backButton.setImage(UIImage(named: "backArrow"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(tappedBack), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.size.equalTo(backButtonSize)
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
        }
    }

    private func getCellSize() {
        let width = (view.frame.width - CGFloat(2 * tableHorizontalOffset)) / 3.0  - mediaCellPadding
        let height = width * 3 / 2
        collectionViewCellSize = CGSize(width: width, height: height)
    }

    private func setupConstraints() {
        let chevronSize = CGSize(width: 30, height: 30)
        let labelLeadingOffset = 36
        let verticalOffset = 20

        titleLabel.snp.makeConstraints { make in
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
            make.leading.equalTo(selectedLabel.snp.trailing)
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

//        suggestedMediaCollectionView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(tableHorizontalOffset)
//            make.top.equalTo(resultLabel.snp.bottom).offset(verticalOffset)
//            make.bottom.equalToSuperview()
//        }

        selectedMediaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedLabel.snp.bottom).offset(15)
            make.height.equalTo(collectionViewCellSize.height + 10)
            make.leading.trailing.equalToSuperview()
        }

        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(26)
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.height.equalTo(40)
        }

        if type == .toGroup {
            quickAddButton.snp.makeConstraints { make in
                make.top.equalTo(selectedLabel.snp.bottom).offset(verticalOffset)
                make.trailing.equalToSuperview().inset(21)
                make.size.equalTo(CGSize(width: 95, height: 25))
            }
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
        guard !selectedMedia.isEmpty else {
            dismissVC()
            return
        }
        let mediaIds = selectedMedia.map { $0.id }
        switch type {
        case .toGroup:
            guard let groupId = groupId else { return }
            NetworkManager.addToGroup(id: groupId, mediaIds: mediaIds) { [weak self] _ in
                guard let self = self else { return }
                self.selectedMedia = []
                self.dismissVC(isMediaAdded: true)
            }
        case .toList:
            guard let list = list else { return }
            NetworkManager.addToMediaList(listId: list.id, mediaIds: mediaIds) { [weak self] list in
                guard let self = self else { return }
                self.list = list
                self.selectedMedia = []
                self.dismissVC(isMediaAdded: true)
            }
        }
    }

    @objc private func tappedBack() {
        dismissVC()
    }

    @objc private func tappedChevron() {
        isSelectedHidden.toggle()
        chevronButton.setImage(UIImage(named: isSelectedHidden ? "downChevron" : "upChevron"), for: .normal)
        showSelectedMedia()
    }

    @objc private func quickAddTapped() {
        guard type == .toGroup,
              let groupId = groupId else { return }
        NetworkManager.addToGroup(id: groupId, isQuickAdd: true) { [weak self] _ in
            guard let self = self else { return }
            self.dismissVC(isMediaAdded: true)
        }
    }

    @objc private func handleDragToDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            self.backButton.isHidden = true
            viewTranslation = sender.translation(in: view)
            // Show translation animation only when dragging downward
            if viewTranslation.y > 0 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                })
            }
        case .ended:
            if viewTranslation.y < 300 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                }) { _ in
                    self.backButton.isHidden = false
                }
            } else {
                dismissVC()
            }
        default:
            break
        }
    }

    @objc private func getMedia(timer: Timer) {
        if let userInfo = timer.userInfo as? [String: String],
            let searchText = userInfo["searchText"] {
            NetworkManager.searchMedia(query: searchText) { [weak self] query, media in
                guard let self = self, self.isSearching else { return }
                // Update search result only if there's no query or query matches current searchText
                if let query = query, query != self.searchBar.searchTextField.text {
                    return
                }
                DispatchQueue.main.async {
                    self.searchResultMedia = media
                    self.resultLabel.text = "\(self.searchResultMedia.count) Results"
                    self.resultMediaTableView.reloadData()
                }
            }
        }
    }

    private func selectMedia(_ media: SimpleMedia) {
        selectedMedia.append(media)
        selectedLabel.text = "\(selectedMedia.count) Selected"
        let indexPath = IndexPath(item: selectedMedia.count-1, section: 0)
        selectedMediaCollectionView.insertItems(at: [indexPath])
        selectedMediaCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
    }

    private func deselectMedia(_ media: SimpleMedia) {
        let mediaIndex = selectedMedia.firstIndex { $0.id == media.id }
        if let index = mediaIndex {
            selectedMedia.remove(at: index)
            selectedLabel.text = "\(selectedMedia.count) Selected"
            let indexPath = IndexPath(item: index, section: 0)
            selectedMediaCollectionView.deleteItems(at: [indexPath])
        }
    }

    private func reloadSelectedMediaCollectionView() {
        selectedMediaCollectionView.reloadData()
        for item in 0 ..< selectedMedia.count {
            let indexPath = IndexPath(item: item, section: 0)
            selectedMediaCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
        }
    }

    private func dismissVC(isMediaAdded: Bool = false) {
        dismiss(animated: true) {
            self.delegate?.addMediaDismissed()
            if isMediaAdded {
                self.delegate?.reloadMedia()
            }
        }
    }

}

extension AddMediaViewController: UITableViewDataSource, UITableViewDelegate {

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
        let media = searchResultMedia[indexPath.row]
        selectMedia(SimpleMedia(id: media.id, title: media.title, posterPic: media.posterPic))
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let media = searchResultMedia[indexPath.row]
        deselectMedia(SimpleMedia(id: media.id, title: media.title, posterPic: media.posterPic))
    }

}

extension AddMediaViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return collectionView == selectedMediaCollectionView ? selectedMedia.count : suggestedMedia.count
        return selectedMedia.count
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
        // TODO: account for suggested media
        selectMedia(selectedMedia[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // TODO: account for suggested media
        let media = selectedMedia[indexPath.row]
        deselectMedia(media)
        // If deselected media in selected media list, also deselect media in search results or suggested media
        if collectionView == selectedMediaCollectionView {
            if isSearching {
                guard let index = searchResultMedia.firstIndex(where: { $0.id == media.id }) else { return }
                resultMediaTableView.deselectRow(at: IndexPath(item: index, section: 0), animated: true)
            } else {
                // TODO: deselect in suggested media collection view
            }
        }
    }

}

extension AddMediaViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewCellSize
    }

}

extension AddMediaViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            resultLabel.text = ""
            resultMediaTableView.isHidden = true
            quickAddButton.isHidden = false
//            suggestedMediaCollectionView.isHidden = false
        } else {
            isSearching = true
            resultLabel.text = "\(searchResultMedia.count) Results"
            resultMediaTableView.isHidden = false
            quickAddButton.isHidden = true
//            suggestedMediaCollectionView.isHidden = true

            timer?.invalidate()
            timer = Timer.scheduledTimer(
                timeInterval: 0.2,
                target: self,
                selector: #selector(getMedia),
                userInfo: ["searchText": searchText],
                repeats: false
            )
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}
