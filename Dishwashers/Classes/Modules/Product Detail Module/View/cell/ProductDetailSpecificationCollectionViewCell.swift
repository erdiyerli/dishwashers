//
//  ProductDetailSpecificationCollectionViewCell.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 26/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

class ProductDetailSpecificationCollectionViewCell: DynamicSizeCollectionViewCell {

    @IBOutlet private  weak var attributeLabel: UILabel!
    @IBOutlet private  weak var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with attribute: ProductFeatureAttribute) {
        attributeLabel.text = attribute.name
        valueLabel.text = attribute.value
    }

}
