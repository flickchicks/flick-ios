//
//  SortListModalView.swift
//  Flick
//
//  Created by Lucy Xu on 6/20/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SnapKit


class SortListModalView: ModalView {

    // MARK: - Private View Vars
    private let dismissButton = UIButton()
    private var sortOptionsTableView: UITableView!
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    private let sortOptionCellReuseIdentifier = "SortOptionCellReuseIdentifier"
    // TODO: Get selected sort order from backend
    private var sortSelections: [SortSelection] = [
        SortSelection(description: "Recently added", sortDirection: .descending),
        SortSelection(description: "Recently released", sortDirection: .unselected),
        SortSelection(description: "Alphabetical", sortDirection: .unselected),
        SortSelection(description: "Highest rating", sortDirection: .unselected)
    ]

    override init() {
        super.init()

        titleLabel.text = "Sort list"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 18)
        containerView.addSubview(titleLabel)

        dismissButton.setTitle("Done", for: .normal)
        dismissButton.setTitleColor(.gradientPurple, for: .normal)
        dismissButton.titleLabel?.font = .systemFont(ofSize: 14)
        dismissButton.layer.cornerRadius = 12
        dismissButton.layer.backgroundColor = UIColor.lightPurple.cgColor
        dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        containerView.addSubview(dismissButton)

        sortOptionsTableView = UITableView(frame: .zero, style: .plain)
        sortOptionsTableView.dataSource = self
        sortOptionsTableView.delegate = self
        sortOptionsTableView.isScrollEnabled = false
        sortOptionsTableView.register(SortOptionTableViewCell.self, forCellReuseIdentifier: sortOptionCellReuseIdentifier)
        sortOptionsTableView.separatorStyle = .none
        containerView.addSubview(sortOptionsTableView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let containerViewSize = CGSize(width: 325, height: 263)
        let dismissButtonSize = CGSize(width: 60, height: 25)
        let horizontalPadding = 24
        let titleLabelSize = CGSize(width: 67, height: 22)
        let verticalPadding = 36

        containerView.snp.makeConstraints { make in
            make.size.equalTo(containerViewSize)
            make.center.equalToSuperview()
        }

        dismissButton.snp.makeConstraints { make in
            make.size.equalTo(dismissButtonSize)
            make.top.equalTo(containerView).offset(33)
            make.trailing.equalTo(containerView).inset(horizontalPadding)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(verticalPadding)
            make.leading.equalTo(containerView).offset(horizontalPadding)
            make.size.equalTo(titleLabelSize)
        }

        sortOptionsTableView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(dismissButton)
            make.top.equalTo(titleLabel).offset(verticalPadding)
            make.bottom.equalToSuperview().inset(verticalPadding)
        }
    }

    @objc func dismiss() {
        dismissModal()
    }

}

extension SortListModalView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortSelections.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sortOptionCellReuseIdentifier, for: indexPath) as? SortOptionTableViewCell else { return UITableViewCell() }
        cell.configure(for: sortSelections[indexPath.row], at: indexPath.row, delegate: self)
        return cell
    }

}

extension SortListModalView: SortOptionDelegate {
    func setSortSelection(at index: Int, for sortDirection: SortDirection) {
        sortSelections.forEach { $0.sortDirection = .unselected }
        sortSelections[index].sortDirection = sortDirection
        sortOptionsTableView.reloadData()
    }
}
