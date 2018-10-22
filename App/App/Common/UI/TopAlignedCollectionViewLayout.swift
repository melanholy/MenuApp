//
//  TopAlignedCollectionViewLayout.swift
//  App
//
//  Created by Павел Кошара on 17/10/2018.
//  Copyright © 2018 Павел Кошара. All rights reserved.
//

import UIKit

final class TopAlignedCollectionViewLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(
        in rect: CGRect
    ) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var result = [UICollectionViewLayoutAttributes]()
        var sameLine = [UICollectionViewLayoutAttributes]()
        for attribute in attributes {
            let copy = attribute.copy() as! UICollectionViewLayoutAttributes
            if sameLine.count == 0
               || sameLine[sameLine.count - 1].frame.origin.x < copy.frame.origin.x {
                sameLine.append(copy)
                continue
            }

            result.append(contentsOf: align(attributes: sameLine))
            sameLine = [copy]
        }

        result.append(contentsOf: align(attributes: sameLine))

        return result
    }

    func align(attributes: [UICollectionViewLayoutAttributes]) -> [UICollectionViewLayoutAttributes] {
        let minY = attributes.filter {
            $0.representedElementCategory == .cell
        }.min {
            $0.frame.origin.y < $1.frame.origin.y
        }?.frame.origin.y

        return attributes.map { attribute in
            if let minY = minY, attribute.representedElementCategory == .cell {
                attribute.frame.origin = CGPoint(x: attribute.frame.origin.x, y: minY)
            }

            return attribute
        }
    }
}
