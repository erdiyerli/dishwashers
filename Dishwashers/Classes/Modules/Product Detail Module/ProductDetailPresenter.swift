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
    func viewDidTapBackButton()
    func viewOrientationDidChange(orientation: UIDeviceOrientation)
}

class ProductDetailPresenter {

    weak var view: ProductDetailViewInterface?
    fileprivate var wireFrame: WireframeInterface
    fileprivate var interactor: ProductDetailInteractorInput

    private var selectedProduct: Product
    private var productDetail: ProductDetail?
    private var currentDeviceOrientation: UIDeviceOrientation

    init(with product: Product, wireFrame: WireframeInterface, view: ProductDetailViewInterface, interactor: ProductDetailInteractorInput) {
        self.view = view
        self.wireFrame = wireFrame
        self.interactor = interactor
        self.selectedProduct = product
        currentDeviceOrientation = UIDevice.current.orientation
        (view as? UIViewController)?.title = product.title
    }

    private func parseSections() -> ProductDetailViewModel? {
        guard let detail = productDetail else {
            return nil
        }

        if currentDeviceOrientation.isPortrait {
            return ProductDetailViewModel(masterSections: [.media(media: detail.media),
                                                           .offers(price: detail.price, specialOffer: detail.displaySpecialOffer, includedServices: detail.includedServices ),
                                                           .productInformation(information: detail.productInformation, productCode: detail.code),
                                                           .productSpecification(features: detail.features)],
                                   detailSections: [])
        }

        return ProductDetailViewModel(masterSections: [.media(media: detail.media),
                                                       .productInformation(information: detail.productInformation, productCode: detail.code),
                                                       .readMore,
                                                       .productSpecification(features: detail.features)],
                                      detailSections: [.offers(price: detail.price, specialOffer: detail.displaySpecialOffer, includedServices: detail.includedServices )])
    }
}

extension ProductDetailPresenter: ProductDetailPresenterInterface {
    func viewOrientationDidChange(orientation: UIDeviceOrientation) {
        currentDeviceOrientation = orientation
        guard let model = parseSections() else {return}
        view?.update(state:.success(data: model))
    }

    func viewDidLoad() {
        interactor.loadProductDetail(product: selectedProduct)
    }

    func viewDidTapBackButton() {
        wireFrame.popFromNavigationController(animated: true)
    }
}

extension ProductDetailPresenter: ProductDetailInteractorOutput {
    func didFinishLoading(productDetail detail: ProductDetail) {
        self.productDetail = detail
        guard let model = parseSections() else {return}
        view?.update(state:.success(data: model))
    }

    func didFailLoadingProductDetail(with error: Error) {
        view?.update(state: .error(message: error.localizedDescription))
    }
}
