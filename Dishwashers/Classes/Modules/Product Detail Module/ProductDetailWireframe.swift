//
//  ProductDetailWireframe.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

class ProductDetailWireframe: BaseWireframe {

    private let storyboard = UIStoryboard(name: "ProductDetail", bundle: nil)

    private func configure(with product: Product, view: ProductDetailViewController) {
        let interactor = ProductDetailInteractor()
        let presenter = ProductDetailPresenter(with: product, wireFrame: self, view: view, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
    }

    func show(product: Product, with transition: Transition, animated: Bool) {
        let view = storyboard.instantiateInitialViewController() as! ProductDetailViewController
        configure(with: product, view: view)
        show(view, with: transition, animated: animated)
    }

}
