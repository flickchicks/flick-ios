//
//  SortOptionTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 6/20/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol SortOptionDelegate: class {
    func setSortSelection(at index: Int, for sortDirection: SortDirection)
}

class SortOptionTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let ascendButton = UIButton()
    private let descendButton = UIButton()
    private let sortLabel = UILabel()

    // MARK: - Private Data Vars
    weak var delegate: SortOptionDelegate?
    // Keep track of which sort option to modify in array
    private var index: Int!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        sortLabel.font = .systemFont(ofSize: 16)
        addSubview(sortLabel)

        descendButton.imageView?.contentMode = .scaleAspectFit
        descendButton.addTarget(self, action: #selector(setDescendingSort), for: .touchUpInside)
        addSubview(descendButton)

        ascendButton.imageView?.contentMode = .scaleAspectFit
        ascendButton.addTarget(self, action: #selector(setAscendingSort), for: .touchUpInside)
        addSubview(ascendButton)

        setupConstraints()
    }

    func configure(for sortSelection: SortSelection, at index: Int, delegate: SortOptionDelegate) {
        self.delegate = delegate
        self.index = index
        sortLabel.text = sortSelection.description
        setColors(sortDirection: sortSelection.sortDirection)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let buttonHeight = 9.5

        sortLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }

        ascendButton.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.height.equalTo(buttonHeight)
        }

        descendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(ascendButton.snp.leading).offset(-4)
            make.height.equalTo(buttonHeight)
        }

    }

    private func setColors(sortDirection: SortDirection) {
        sortLabel.textColor = sortDirection == .unselected ? .darkBlueGray2 : .gradientPurple
        let ascentImageName = sortDirection == .ascending ? "filledUpArrow" : "upArrow"
        let descendImageName = sortDirection == .descending ? "filledDownArrow" : "downArrow"
        ascendButton.setImage(UIImage(named: ascentImageName), for: .normal)
        descendButton.setImage(UIImage(named: descendImageName), for: .normal)
    }

    @objc func setAscendingSort() {
        delegate?.setSortSelection(at: index, for: .ascending)
    }

    @objc func setDescendingSort() {
        delegate?.setSortSelection(at: index, for: .descending)
    }

}
