//
//  Product.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 23/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

struct Product: Decodable {
    let id: String
    let title: String
    let imageURL: String
    let price: ProductPrice

    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case title
        case imageURL = "image"
        case price
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        price = try container.decode(ProductPrice.self, forKey: .price)
    }
}
