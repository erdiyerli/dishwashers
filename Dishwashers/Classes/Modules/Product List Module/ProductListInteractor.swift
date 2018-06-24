//
//  ProductListInteractor.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

protocol ProductListInteractorInput: class {
    func loadProductList()
}

protocol ProductListInteractorOutput: class {
    func didFinishLoading(products: [Product])
    func didFailLoading(with error: Error)
}

class ProductListInteractor {
    weak var output: ProductListInteractorOutput?
}

extension ProductListInteractor: ProductListInteractorInput {
    func loadProductList() {
    }
}
