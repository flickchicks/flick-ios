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
//        let imgRect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
//        UIGraphicsBeginImageContextWithOptions(size, false, scale)
//        self.draw(in: imgRect)
//        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return resizedImage!
        
        
        let imageSize = self.size
        let newWidth  = size.width  / self.size.width
        let newHeight = size.height / self.size.height
        var newSize: CGSize

        if(newWidth > newHeight) {
            newSize = CGSize(width: imageSize.width * newHeight, height: imageSize.height * newHeight)
        } else {
            newSize = CGSize(width: imageSize.width * newWidth, height: imageSize.height * newWidth)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.width)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        self.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
        
    }

    func toBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 1) else { return nil }
        return imageData.base64EncodedString()
    }
}
