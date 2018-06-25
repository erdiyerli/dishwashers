//
//  ViewState.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 25/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

enum ViewState<T> {
    case loading
    case error(message: String)
    case success(data: T)
}
