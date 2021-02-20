//
//  EmptyStateView.swift
//  Flick
//
//  Created by Lucy Xu on 2/6/21.
//  Copyright © 2021 flick. All rights reserved.
//

import UIKit

enum EmptyStateType {
    case suggestions
    case activity
    case search
    case group
    
    var image: String {
        switch self {
        case .suggestions:
            return "emptySuggestions"
        case .activity:
            return "emptyActivity"
        case .search:
            return "emptySearch"
        case .group:
            return "emptyGroups"
        }
    }

    var title: String {
        switch self {
        case .suggestions:
            return "No suggestions"
        case .activity:
            return "*Crickets*"
        case .search:
            return "Nothing popped up"
        case .group:
            return "No groups yet"
        }
    }
    
    var subtitle: String {
        switch self {
        case .suggestions:
            return "Find friends to start sharing your shows"
        case .activity:
            return "Recent activity will show here"
        case .search:
            return "Try searching for something else"
        case .group:
            return "Create a group to pick what to watch together"
        }
    }

}

class EmptyStateView: UIView {
    
    // MARK: - Private View Vars
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    init(type: EmptyStateType) {
        super.init(frame: .zero)
        
        backgroundColor = .purple
        
        imageView.image = UIImage(named: type.image)
        addSubview(imageView)
        
        titleLabel.text = type.title
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.textColor = .mediumGray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        subtitleLabel.text = type.subtitle
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .mediumGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        addSubview(subtitleLabel)
        
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 280, height: 200))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalTo(imageView)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalTo(imageView)
            make.leading.trailing.equalToSuperview()
        }
    }
}
