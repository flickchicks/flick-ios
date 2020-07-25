//
//  CommentTableViewCell.swift
//  Flick
//
//  Created by Lucy Xu on 7/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class UILabelPadding: UILabel {

    let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }

}

class CommentTableViewCell: UITableViewCell {

    private let profileImageView = UIImageView()
    private let commentLabel = UILabelPadding()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .none

        profileImageView.layer.backgroundColor = UIColor.lightPurple.cgColor
        profileImageView.layer.cornerRadius = 20
        addSubview(profileImageView)

        commentLabel.layer.backgroundColor = UIColor.lightGray2.cgColor
//        commentLabel.intrinsicContentSize.height = commentLabel.intrinsicContentSize.height + 20
//        commentLabel.intrinsicContentSize.width = commentLabel.intrinsicContentSize.width + 20
        commentLabel.font = .systemFont(ofSize: 12)
        commentLabel.textColor = .black
        commentLabel.numberOfLines = 0
        commentLabel.layer.cornerRadius = 16
        addSubview(commentLabel)

        nameLabel.font = .systemFont(ofSize: 10)
        nameLabel.textColor = .mediumGray
        addSubview(nameLabel)

        dateLabel.font = .systemFont(ofSize: 10)
        dateLabel.textColor = .mediumGray
        addSubview(dateLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {

        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview()
//            make.centerY.equalToSuperview()
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(12)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.height.equalTo(12)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(20)
        }

        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
//            make.height.equalTo(12)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-38)
            make.leading.equalTo(nameLabel)
//            make.width.equalTo(20)
        }

    }

    func configure(for comment: Comment) {
        commentLabel.text = comment.comment
        nameLabel.text = comment.name
        dateLabel.text = comment.date
    }
}
