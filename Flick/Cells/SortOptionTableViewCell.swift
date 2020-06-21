//
//  SortOptionTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 6/20/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

protocol SortOptionDelegate: class {
    func setSortSelection(at index: Int, for sortDirection: SortDirection )
}

class SortOptionTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let sortLabel = UILabel()
    private let ascendButton = UIButton()
    private var descendButton = UIButton()

    // MARK: - Private Data Vars
    weak var delegate: SortOptionDelegate?
    private var index: Int!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        sortLabel.font = .systemFont(ofSize: 16)
        addSubview(sortLabel)

        ascendButton.imageView?.contentMode = .scaleAspectFit
        ascendButton.addTarget(self, action: #selector(setAscendingSort), for: .touchUpInside)
        addSubview(ascendButton)

        descendButton.imageView?.contentMode = .scaleAspectFit
        descendButton.addTarget(self, action: #selector(setDescendingSort), for: .touchUpInside)
        addSubview(descendButton)

        setupConstraints()
    }

    func configure(for sortSelection: SortSelection, at index: Int, delegate: SortOptionDelegate) {
        self.delegate = delegate
        self.index = index
        sortLabel.text = sortSelection.description
        sortLabel.textColor = sortSelection.sortDirection == .unselected ? .darkBlueGray2 : .gradientPurple
        if (sortSelection.sortDirection == .ascending) {
            ascendButton.setImage(UIImage(named: "filledUpArrow"), for: .normal)
            descendButton.setImage(UIImage(named: "downArrow"), for: .normal)
        } else if (sortSelection.sortDirection == .descending) {
            ascendButton.setImage(UIImage(named: "upArrow"), for: .normal)
            descendButton.setImage(UIImage(named: "filledDownArrow"), for: .normal)
        } else {
            ascendButton.setImage(UIImage(named: "upArrow"), for: .normal)
            descendButton.setImage(UIImage(named: "downArrow"), for: .normal)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let buttonHeight = 9.5

        sortLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }

        descendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(buttonHeight)
        }

        ascendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(descendButton.snp.leading).offset(-4)
            make.height.equalTo(buttonHeight)
        }

    }

    @objc func setAscendingSort() {
        delegate?.setSortSelection(at: index, for: .ascending)
    }

    @objc func setDescendingSort() {
        delegate?.setSortSelection(at: index, for: .descending)
    }

}
