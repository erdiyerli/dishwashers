//
//  ProductListInteractor.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import Base

protocol ProductListInteractorInput: class {
    func loadProductList()
}

protocol ProductListInteractorOutput: class {
    func didFinishLoading(searchResult: SearchResult)
    func didFailLoading(with error: Error)
}

class ProductListInteractor {
    weak var output: ProductListInteractorOutput?

    private let query = "dishwasher"
    private let pageSize = 20
}

extension ProductListInteractor: ProductListInteractorInput {
    func loadProductList() {

        let resource = Product.search(query: query, pageSize: pageSize)
        Network.Webservices.baseURL(DishwashersAPI.baseURL).request(resource) { [weak self] (result) in
            switch result {
            case .error(let error):
                self?.output?.didFailLoading(with: error)
            case .success(let result):
                self?.output?.didFinishLoading(searchResult: result)
            }
        }
    }
}
