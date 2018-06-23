//
//  ProductDetail.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 23/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

struct ProductDetail: Decodable {
    let id: String
    let title: String
    let code: String
    let media: ProductMedia
    let price: ProductPrice
    let productInformation: String
    let displaySpecialOffer: String
    let includedServices: [String]
    let features: [ProductFeature]

    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case title
        case code
        case price
        case media = "media"
        case details = "details"
        case displaySpecialOffer
        case additionalServices = "additionalServices"
    }

    enum MediaCodingKeys: String, CodingKey {
        case images
    }

    enum DetailCodingKeys: String, CodingKey {
        case productInformation
        case features
    }

    enum AdditionalServicesCodingKeys: String, CodingKey {
        case includedServices
    }


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        code = try container.decode(String.self, forKey: .code)
        price = try container.decode(ProductPrice.self, forKey: .price)
        displaySpecialOffer = try container.decode(String.self, forKey: .displaySpecialOffer)

        let mediaContainer = try container.nestedContainer(keyedBy: MediaCodingKeys.self, forKey: .media)
        media = try mediaContainer.decode(ProductMedia.self, forKey: .images)

        let detailContainer = try container.nestedContainer(keyedBy: DetailCodingKeys.self, forKey: .details)
        productInformation = try detailContainer.decode(String.self, forKey: .productInformation)
        features  = try detailContainer.decode([ProductFeature].self, forKey: .features)

        let additionalServicesContainer = try container.nestedContainer(keyedBy: AdditionalServicesCodingKeys.self, forKey: .additionalServices)
        includedServices = try additionalServicesContainer.decode([String].self, forKey: .includedServices)
    }
}

struct ProductMedia: Decodable {
    let altText: String
    let urls: [String]
}

struct ProductFeature: Decodable {
    let attributes: [ProductFeatureAttribute]
}

struct ProductFeatureAttribute: Decodable {
    let name: String
    let value: String
}
