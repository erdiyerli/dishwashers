//
//  Product.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 23/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import Base
import Foundation

struct Product: Decodable {
    let id: String
    let title: String
    let image: String
    let price: ProductPrice

    var imageURL: URL? {
        return URL(string: "https:\(image)")
    }

    enum CodingKeys: String, CodingKey {
        case id = "productId"
        case title
        case image
        case price
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        image = try container.decode(String.self, forKey: .image)
        price = try container.decode(ProductPrice.self, forKey: .price)
    }
}

extension Product {

    func producDetail()-> Resource<ProductDetail> {
        return Resource(endpoint: DishwashersAPI.endpoints.products(productID: id).url,
                        parse: { (data) -> (Result<ProductDetail>) in
            do {
                let decoder = JSONDecoder()
                let productDetail = try decoder.decode(ProductDetail.self, from: data)
                return Result<ProductDetail>.success(productDetail)
            } catch {
                return Result.error( DiswashersError<DataError>(type: .parse))
            }
        })
    }

    static func search(query: String, pageSize: Int) -> Resource<SearchResult> {
        let queries = [ URLQueryItem(name: "q", value: query),
                        URLQueryItem(name: "pageSize", value: "\(pageSize)"),
                        URLQueryItem(name: "key", value: "Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb")]

        return Resource(endpoint: DishwashersAPI.endpoints.search.url,
                                   method: .get(nil),
                                   query: queries,
                                   headerProvider: nil,
                                   cancellationPolicy: .none,
                                   errorResponseHandler: { (code, data) -> (Error?) in
                return DiswashersError<DataError>(type: .unhandled)
        }, parse: { (data) -> (Result<SearchResult>) in

            do {
                let decoder = JSONDecoder()

                let searchResult = try decoder.decode(SearchResult.self, from: data)

                return Result<SearchResult>.success(searchResult)

            } catch {
                return Result.error(DiswashersError<DataError>(type: .parse))
            }

        })
    }
}
