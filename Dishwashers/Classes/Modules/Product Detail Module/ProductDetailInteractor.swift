//
//  ProductDetailInteractor.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 25/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import Base

protocol ProductDetailInteractorInput: class {
    func loadProductDetail(product: Product)
}

protocol ProductDetailInteractorOutput: class {
    func didFinishLoading(productDetail detail: ProductDetail)
    func didFailLoadingProductDetail(with error: Error)
}

class ProductDetailInteractor {
    weak var output: ProductDetailInteractorOutput?
}

extension ProductDetailInteractor: ProductDetailInteractorInput {
    func loadProductDetail(product: Product) {

        let resource = product.producDetail()
        Network.Webservices.baseURL(DishwashersAPI.baseURL).request(resource) { [weak self] (result) in
            switch result {
            case .error(let error):
                self?.output?.didFailLoadingProductDetail(with: error)
            case .success(let detail):
                self?.output?.didFinishLoading(productDetail: detail)
            }
        }
    }
}

