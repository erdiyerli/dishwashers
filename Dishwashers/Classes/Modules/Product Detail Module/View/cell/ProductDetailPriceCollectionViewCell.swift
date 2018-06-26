//
//  ProductDetailPriceCollectionViewCell.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 26/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

class ProductDetailPriceCollectionViewCell: DynamicSizeCollectionViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var specialOfferLabel: UILabel!
    @IBOutlet weak var includedServicesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with price: String, specialOffer: String, includedServices: [String]) {
        priceLabel.text = price
        specialOfferLabel.text = specialOffer
        includedServicesLabel.text = includedServices.joined(separator: "\n")

        specialOfferLabel.isHidden = specialOffer.count < 1
        includedServicesLabel.isHidden = includedServices.count < 1
    }

}
