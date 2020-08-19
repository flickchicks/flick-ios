//
//  ListNameTableViewCell.swift
//  Flick
//
//  Created by Haiying W on 8/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class ListNameTableViewCell: UITableViewCell {

    // MARK: - Private View Vars
    private let iconImageView = UIImageView()
    private let selectIndicatorView = SelectIndicatorView(width: 20)
    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        titleLabel.textColor = .darkBlueGray2
        titleLabel.font = .systemFont(ofSize: 16)
        contentView.addSubview(titleLabel)

        contentView.addSubview(selectIndicatorView)

        setupConstraints()
    }

    private func setupConstraints() {
        let selectIndicatorSize = CGSize(width: 20, height: 20)

        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.trailing.equalTo(selectIndicatorView.snp.leading).offset(-5)
        }

        selectIndicatorView.snp.makeConstraints { make in
            make.size.equalTo(selectIndicatorSize)
            make.trailing.centerY.equalToSuperview()
        }
    }

    func configure(list: SimpleMediaList) {
        titleLabel.text = list.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selected ? selectIndicatorView.select() : selectIndicatorView.deselect()
     }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
