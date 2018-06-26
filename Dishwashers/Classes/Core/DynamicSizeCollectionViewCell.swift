//
//  DynamicSizeCollectionViewCell.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 26/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

class DynamicSizeCollectionViewCell: UICollectionViewCell {

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
