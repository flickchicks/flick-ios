//
//  NSMutableAttributedString.swift
//  Flick
//
//  Created by Lucy Xu on 8/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    func boldFont14(_ value:String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key : UIFont] = [
        .font : .boldSystemFont(ofSize: 14)
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normalFont14(_ value:String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key : UIFont] = [
            .font : .systemFont(ofSize: 14),
        ]
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
