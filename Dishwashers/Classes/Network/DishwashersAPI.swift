//
//  DishwashersAPI.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

struct DishwashersAPI {
    static let baseURL = "https://api.johnlewis.com/v1"

    enum endpoints {
        case search
        case products(productID: String)

        var url: String {
            switch self {
            case .search: return "/products/search"
            case .products(let productID): return "/products/\(productID)"
            }
        }
    }
}

