//
//  SelfSizeCollectionView.swift
//  Flick
//
//  Created by Lucy Xu on 7/10/20.
//  Copyright © 2020 flick. All rights reserved.
//

import UIKit

/// SelfSizingCollectionView is a collection view that calculates its own height and does not require height constraints
class SelfSizingCollectionView: UICollectionView {
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        return self.collectionViewLayout.collectionViewContentSize
    }
}
