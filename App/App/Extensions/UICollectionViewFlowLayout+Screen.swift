//
//  UICollectionViewFlowLayout+App.swift
//  App
//
//  Created by Павел Кошара on 19/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

extension UICollectionViewFlowLayout {
    var sizeWithoutInsets: CGSize {
        get {
            guard let collectionView = collectionView else {
                return CGSize(width: 0, height: 0)
            }

            let fullSize = collectionView.bounds.size
            let widthWithoutInsets = fullSize.width
                - sectionInset.left - sectionInset.right
                - collectionView.contentInset.left - collectionView.contentInset.right
            let heightWithoutInsets = fullSize.height
                - sectionInset.top - sectionInset.bottom
                - collectionView.contentInset.top - collectionView.contentInset.bottom

            return CGSize(width: widthWithoutInsets, height: heightWithoutInsets)
        }
    }
}
