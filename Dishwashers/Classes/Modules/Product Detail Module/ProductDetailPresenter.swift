//
//  ProductDetailPresenter.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 25/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

protocol ProductDetailPresenterInterface {
    func viewDidLoad()
}

class ProductDetailPresenter {

    weak var view: ProductDetailViewInterface?
    fileprivate var wireFrame: ProductDetailWireframe
    fileprivate var interactor: ProductDetailInteractorInput

    private var selectedProduct: Product

    init(with product: Product, wireFrame: ProductDetailWireframe, view: ProductDetailViewInterface, interactor: ProductDetailInteractorInput) {
        self.view = view
        self.wireFrame = wireFrame
        self.interactor = interactor
        self.selectedProduct = product
    }
}

extension ProductDetailPresenter: ProductDetailPresenterInterface {
    func viewDidLoad() {
        interactor.loadProductDetail(product: selectedProduct)
    }
}

extension ProductDetailPresenter: ProductDetailInteractorOutput {
    func didFinishLoading(productDetail detail: ProductDetail) {
        
    }

    func didFailLoadingProductDetail(with error: Error) {
        view?.update(state: .error(message: error.localizedDescription))
    }
}
