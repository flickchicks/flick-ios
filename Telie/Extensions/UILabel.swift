//
//  UILabel.swift
//  Flick
//
//  Created by Lucy Xu on 7/25/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

extension UILabel{

public var requiredHeight: CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    label.text = text
    label.attributedText = attributedText
    label.sizeToFit()
    return label.frame.height
  }
}
