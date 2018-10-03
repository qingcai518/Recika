//
//  PointLayout.swift
//  Recika
//
//  Created by liqc on 2018/10/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class PointLayout: UICollectionViewFlowLayout {
    var pageWidth: CGFloat {
        return self.itemSize.width + self.minimumLineSpacing
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {return CGPoint.zero}
        let currentPage = collectionView.contentOffset.x / pageWidth
        if (abs(velocity.x) > 0.2) {
            let nextPage = velocity.x > 0 ? ceil(currentPage) : floor(currentPage)
            return CGPoint(x: nextPage * self.pageWidth, y: proposedContentOffset.y)
        } else {
            return CGPoint(x: round(currentPage) * pageWidth, y: proposedContentOffset.y)
        }
    }
}
