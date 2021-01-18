//
//  UIImage.swift
//  Flick
//
//  Created by Lucy Xu on 8/30/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

extension UIImage {

    func resize(toSize targetSize: CGSize) -> UIImage {
        let horizontalRatio = targetSize.width / size.width
        let verticalRatio = targetSize.height / size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }

    func toBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 1) else { return nil }
        return imageData.base64EncodedString()
    }
    
}
