//
//  ProductListPresenter.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

protocol ProductListPresenterInput: class {
    func viewDidLoad()
    func viewDidSelect(item: Product)
}

class ProductListPresenter {
    weak var view: ProductListViewInterface?
    fileprivate var wireFrame: ProductListWireframeInterface
    fileprivate var interactor: ProductListInteractorInput

    init(wireFrame: ProductListWireframeInterface, view: ProductListViewInterface, interactor: ProductListInteractorInput) {
        self.view = view
        self.wireFrame = wireFrame
        self.interactor = interactor
    }
}

extension ProductListPresenter: ProductListPresenterInput {
    func viewDidLoad() {
        interactor.loadProductList()
    }

    func viewDidSelect(item: Product) {
        wireFrame.navigate(to: .productDetail(product: item))
    }
}

extension ProductListPresenter: ProductListInteractorOutput {
    func didFinishLoading(products: [Product]) {
        view?.update(state: .success(data: products))
    }

    func didFailLoading(with error: Error) {
        view?.update(state: .error(message: error.localizedDescription))
    }
}
