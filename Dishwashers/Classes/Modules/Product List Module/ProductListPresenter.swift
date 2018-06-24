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
    func viewDidSelectItem(at indexPath: IndexPath)
}

class ProductListPresenter {
    weak var view: ProductListViewInterface?
    fileprivate var wireFrame: ProductListWireframeInterface
    fileprivate var interactor: ProductListInteractorInput

    private var searchResult: SearchResult?

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

    func viewDidSelectItem(at indexPath: IndexPath) {
        guard let item = searchResult?.products[indexPath.item] else {return}
        wireFrame.navigate(to: .productDetail(product: item))
    }
}

extension ProductListPresenter: ProductListInteractorOutput {
    func didFinishLoading(searchResult: SearchResult) {
        self.searchResult = searchResult
        let models = searchResult.products.compactMap({ ProductListCollectionViewCellModel.init(title: $0.title, imageURL: $0.imageURL, price: $0.price.now) })
        view?.update(state: .success(results: searchResult.results, models: models))
    }

    func didFailLoading(with error: Error) {
        view?.update(state: .error(message: error.localizedDescription))
    }
}
