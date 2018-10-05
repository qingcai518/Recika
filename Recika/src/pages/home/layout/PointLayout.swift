//
//  PointLayout.swift
//  Recika
//
//  Created by liqc on 2018/10/03.
//  Copyright © 2018年 liqc. All rights reserved.
//

import UIKit

class PointLayout: UICollectionViewFlowLayout {
    var lastOffset = CGPoint.zero
    
    var pageWidth: CGFloat {
        return self.itemSize.width + self.minimumLineSpacing
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var result = proposedContentOffset
        guard let collectionView = collectionView else {return result}
        
        let offsetMax: CGFloat = collectionView.contentSize.width - (pageWidth + self.sectionInset.right)
        let offsetMin: CGFloat = 0
        
        if lastOffset.x < offsetMin {
            lastOffset.x = offsetMin
        } else if lastOffset.x > offsetMax {
            lastOffset.x = offsetMax
        }
        
        let offsetForCurrentPointX = abs(proposedContentOffset.x - lastOffset.x)
        let offset = proposedContentOffset.x > lastOffset.x ? pageWidth : -pageWidth   // 向左.向右的位移量.
        
        if offsetForCurrentPointX > pageWidth / 2 && lastOffset.x >= offsetMin && lastOffset.x <= offsetMax {
            result = CGPoint(x: lastOffset.x + offset, y: proposedContentOffset.y)
        } else {
            result = CGPoint(x: lastOffset.x, y: lastOffset.y)
        }
        
        lastOffset.x = result.x
        return result
    }
}
