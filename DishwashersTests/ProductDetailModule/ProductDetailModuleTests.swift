//
//  ProductDetailModuleTests.swift
//  DishwashersTests
//
//  Created by Erdi Yerli on 25/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import XCTest
import Base
@testable import Dishwashers

class ProductDetailModuleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testProductDetailView() {

        let mockPresenter = MockProductDetailPresenter()
        let view = ProductDetailViewController(nibName: nil, bundle: nil)
        view.presenter = mockPresenter

        _ = view.view

        XCTAssertTrue(mockPresenter.viewDidLoadCalled)
    }

    func testProductDetailPresenter() {

        let view = MockProductDetailView()
        let wireframe = ProductDetailWireframe(navigationController: UINavigationController())
        let mockInteractor = MockProductDetailInteractor()

        let product = Product(id: "5")

        let presenter = ProductDetailPresenter(with: product, wireFrame: wireframe, view: view, interactor: mockInteractor)

        presenter.viewDidLoad()

        XCTAssertEqual(mockInteractor.product?.id, "5")

        let error = NSError(domain: "", code: 0, userInfo: [:])

        presenter.didFailLoadingProductDetail(with: error)

        guard case ViewState<Any>.error(_)? = view.state else {
            XCTFail()
            return
        }

    }

    func testProductDetailWireframe() {

        let product = Product(id: "5")

        let nav = UINavigationController()

        let wireframe = ProductDetailWireframe(navigationController: nav)
        wireframe.show(product: product, with: .push, animated: false)

        let detailvc = nav.topViewController as? ProductDetailViewController
        XCTAssertNotNil(detailvc)

    }

    func testProductDetailInteractor() {

        let exp = expectation(description: "product detail interactor load product detail")

        let interactor = ProductDetailInteractor()
        let mockPresenter = MockProductDetailPresenter(expectation: exp)

        interactor.output = mockPresenter
        mockPresenter.interactor = interactor


        let responseStub = URLResponseStub(statusCode: 200, headers: [:], payloadFileName: "productDetail.json")

        let mockSession = TestURLSession(stubResponse: responseStub)

        Network.Webservices.add(baseURL: DishwashersAPI.baseURL, authorizationHandler: nil, defaultHeaders: nil, session: mockSession)

        let product = Product(id: "")
        interactor.loadProductDetail(product: product)

        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNotNil(mockPresenter.productDetail)
        }
    }

    func testProductDetailInteractorLoadFail() {

        let exp = expectation(description: "product detail interactor load product fail")

        let interactor = ProductDetailInteractor()
        let mockPresenter = MockProductDetailPresenter(expectation: exp)

        interactor.output = mockPresenter
        mockPresenter.interactor = interactor


        let responseStub = URLResponseStub(statusCode: 400, headers: [:], payloadFileName: "productDetail.json")

        let mockSession = TestURLSession(stubResponse: responseStub)

        Network.Webservices.add(baseURL: DishwashersAPI.baseURL, authorizationHandler: nil, defaultHeaders: nil, session: mockSession)

        let product = Product(id: "")
        interactor.loadProductDetail(product: product)

        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNotNil(mockPresenter.error)
        }
    }
}

private extension Product {
    init(id: String) {
        self.id = id
        self.image = ""
        self.title = ""
        self.price = ProductPrice(was: "", then1: "", then2: "", now: "", currency: "")
    }
}

class MockProductDetailView: ProductDetailViewInterface {
    private(set) var state: ViewState<Any>?

    func update(state: ViewState<Any>) {
        self.state = state
    }
}

class MockProductDetailPresenter: ProductDetailPresenterInterface, ProductDetailInteractorOutput {
    private(set) var viewDidLoadCalled = false
    private(set) var error: Error?
    private(set) var productDetail: ProductDetail?
    private(set) var expectation: XCTestExpectation?

    var interactor: ProductDetailInteractorInput?

    init(expectation: XCTestExpectation? = nil) {
        self.expectation = expectation
    }

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didFailLoadingProductDetail(with error: Error) {
        self.error = error
        expectation?.fulfill()
    }

    func didFinishLoading(productDetail detail: ProductDetail) {
        self.productDetail = detail
        expectation?.fulfill()
    }
}

class MockProductDetailInteractor: ProductDetailInteractorInput {
    private(set) var product: Product?

    func loadProductDetail(product: Product) {
        self.product = product
    }

}
