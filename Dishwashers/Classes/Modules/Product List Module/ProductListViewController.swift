//
//  ProductListViewController.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

enum ProductListViewState {
    case loading
    case error(message: String)
    case success(data: [Product])
}

protocol ProductListViewInterface: class {
    func update(state: ProductListViewState)
}

class ProductListViewController: UIViewController {

    var presenter: ProductListPresenterInput?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ProductListViewController: ProductListViewInterface {
    func update(state: ProductListViewState) {
    }
}
