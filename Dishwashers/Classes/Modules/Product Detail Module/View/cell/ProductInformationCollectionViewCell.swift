//
//  ProductInformationCollectionViewCell.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 26/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

struct ProductInformationCollectionViewCellModel {
    let informationText: String
    let productCodeText: String
    let shouldDisplayProductCode: Bool
    let informationLabelNumberOfLines: Int

    init(information: String, productCode: String, landscape: Bool) {

        let informationString = information
        let producCodeString = "Product code: \(productCode)"

        informationText = landscape ? "\(producCodeString)\n\(informationString)" : informationString
        productCodeText = landscape ? "" : producCodeString
        shouldDisplayProductCode = !landscape
        informationLabelNumberOfLines = landscape ? 6 : 4
    }
}

class ProductInformationCollectionViewCell: DynamicSizeCollectionViewCell {

    @IBOutlet private weak var productCodeLabel: UILabel!
    @IBOutlet private weak var informationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with model: ProductInformationCollectionViewCellModel) {
        informationLabel.numberOfLines = model.informationLabelNumberOfLines
        informationLabel.text = model.informationText

        if model.shouldDisplayProductCode {
            productCodeLabel.text = model.productCodeText
            productCodeLabel.isHidden = false
        } else {
            productCodeLabel.isHidden = true
        }
    }

}
