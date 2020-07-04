//
//  SearchBar.swift
//  Flick
//
//  Created by Haiying W on 7/2/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {

    init() {
        super.init(frame: .zero)

        backgroundImage = UIImage()
        searchTextField.backgroundColor = .clear
        searchTextField.textColor = .mediumGray
        searchTextField.font = .systemFont(ofSize: 12)
        searchTextField.clearButtonMode = .never
        layer.cornerRadius = 18
        layer.borderWidth = 1
        layer.borderColor = UIColor.mediumGray.cgColor
        searchTextPositionAdjustment = UIOffset(horizontal: 12, vertical: 0)
        showsCancelButton = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
