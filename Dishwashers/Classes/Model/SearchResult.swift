//
//  SearchResult.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

struct SearchResult: Decodable {
    let products: [Product]
    let results: Int
}
