//
//  ProductListWireframe.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

enum ProductListWireframeNavigation {
    case productDetail(product: Product)
}

protocol ProductListWireframeInterface: class {
    func navigate(to option: ProductListWireframeNavigation)
}

final class ProductListWireframe: BaseWireframe {

    private func configure(with controller: ProductListViewController) {
        let interactor = ProductListInteractor()
        let presenter = ProductListPresenter(wireFrame: self, view: controller, interactor: interactor)
        controller.presenter = presenter
        interactor.output = presenter
    }

    func show(with transition: Transition, animated: Bool) {
        let view = ProductListViewController(nibName: nil, bundle: nil)
        configure(with: view)
        self.show(view, with: transition, animated: animated)
    }

}

extension ProductListWireframe: ProductListWireframeInterface {
    func navigate(to option: ProductListWireframeNavigation) {

    }
}
