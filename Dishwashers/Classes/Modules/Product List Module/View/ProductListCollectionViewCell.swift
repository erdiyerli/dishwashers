//
//  ProductListCollectionViewCell.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit
import Kingfisher

struct ProductListCollectionViewCellModel {
    let desc: NSAttributedString
    let imageURL: URL?

    init(title: String, imageURL: URL?, price: String) {

        let desc = NSAttributedString(string: title, attributes: [.font : UIFont.systemFont(ofSize: 14.0, weight: .regular)])
        let price = NSAttributedString(string: price, attributes: [.font : UIFont.systemFont(ofSize: 14.0, weight: .bold)])

        let attributed = NSMutableAttributedString(attributedString: desc)
        attributed.append(NSAttributedString(string: "\n"))
        attributed.append(price)

        self.desc = attributed
        self.imageURL = imageURL
    }
}

class ProductListCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with model: ProductListCollectionViewCellModel) {
        titleLabel.attributedText = model.desc

        guard let url = model.imageURL else {
            return
        }

        imageView.kf.setImage(with: url)
    }

}
