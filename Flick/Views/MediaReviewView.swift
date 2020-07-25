//
//  MediaReviewView.swift
//  Flick
//
//  Created by Lucy Xu on 7/19/20.
//  Copyright © 2020 flick. All rights reserved.
//

import Foundation
import UIKit

class MediaReviewView: UIView {

    // MARK: - Private View Vars
    private let titleLabel = UILabel()
//    private var commentsTableView: UITableView!
    private let commentsTableView = UITableView(frame: .zero, style: .plain)
    private let ratingSlider = UISlider()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        titleLabel.text = "What people think"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        addSubview(titleLabel)


        setupConstraints()

    }

    private func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(22)
        }

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
