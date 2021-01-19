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

        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        barTintColor = .clear
        backgroundColor = .clear
        isTranslucent = true
        searchTextField.backgroundColor = .white
        searchTextField.textColor = .mediumGray
        searchTextField.font = .systemFont(ofSize: 14)
        searchTextField.clearButtonMode = .whileEditing
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.cornerRadius = 18
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.borderColor = UIColor.mediumGray.cgColor
        setPositionAdjustment(UIOffset(horizontal: 5, vertical: 0), for: UISearchBar.Icon.search)
        showsCancelButton = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
