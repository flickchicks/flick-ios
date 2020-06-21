//
//  SortListModalView.swift
//  Flick
//
//  Created by Lucy Xu on 6/20/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit
import SnapKit

protocol SortListModalDelegate: class {
    func dismissSortMedia()
}

class SortListModalView: UIView {

    // MARK: - Private View Vars
    private let containerView = UIView()
    private let dismissButton = UIButton()
    private var sortOptionsTableView: UITableView!
    private let titleLabel = UILabel()

    // MARK: - Private Data Vars
    weak var delegate: SortListModalDelegate?
    private let sortOptionCellReuseIdentifier = "SortOptionCellReuseIdentifier"
    // TODO: Get selected sort order from backend
    private var sortSelections: [SortSelection] = [
        SortSelection(description: "Recently added", sortDirection: .descending),
        SortSelection(description: "Recently released", sortDirection: .unselected),
        SortSelection(description: "Alphabetical", sortDirection: .unselected),
        SortSelection(description: "Highest rating", sortDirection: .unselected)
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0.7)

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

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        addSubview(containerView)

        setupViews()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let containerViewSize = CGSize(width: 325, height: 263)
        let dismissButtonSize = CGSize(width: 60, height: 25)
        let titleLabelSize = CGSize(width: 67, height: 22)

        containerView.snp.makeConstraints { make in
            make.size.equalTo(containerViewSize)
            make.center.equalToSuperview()
        }

        dismissButton.snp.makeConstraints { make in
            make.size.equalTo(dismissButtonSize)
            make.top.equalTo(containerView).offset(33)
            make.trailing.equalTo(containerView).inset(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(36)
            make.leading.equalTo(containerView).offset(24)
            make.size.equalTo(titleLabelSize)
        }

        sortOptionsTableView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(dismissButton)
            make.top.equalTo(titleLabel).offset(36)
            make.bottom.equalToSuperview().inset(36)
        }

        // Animate the pop up of error alert view in 0.25 seconds
        UIView.animate(withDuration: 0.25, animations: {
            self.containerView.transform = .init(scaleX: 1.5, y: 1.5)
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })

    }

    @objc func dismiss() {
        UIView.animate(withDuration: 0.15, animations: {
            self.containerView.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.backgroundColor = UIColor(red: 63/255, green: 58/255, blue: 88/255, alpha: 0)
        }) { (_) in
            self.delegate?.dismissSortMedia()
        }
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
