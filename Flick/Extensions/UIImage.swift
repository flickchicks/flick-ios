//
//  UIImage.swift
//  Flick
//
//  Created by Lucy Xu on 8/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

extension UIImage {

    func resize(toSize size:CGSize, scale: CGFloat) -> UIImage {
        let imgRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }

    func toBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 1) else { return nil }
        return imageData.base64EncodedString()
    }
}
