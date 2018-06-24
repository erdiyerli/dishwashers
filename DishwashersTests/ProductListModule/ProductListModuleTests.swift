//
//  ProductListModuleTests.swift
//  DishwashersTests
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import XCTest
import Base
@testable import Dishwashers

class ProductListModuleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProductListWireframe() {

        let navigation = UINavigationController()

        let wireframe = ProductListWireframe(navigationController: navigation)
        wireframe.show(with: .root, animated: false)

        XCTAssert(navigation.topViewController is ProductListViewController)
    }

    func testProductListPresenter() {

        let wireframe = MockProductListWireframe()

        let mockView = MockProductListView()
        let mockInteractor = MockProductListInteractor()
        let presenter = ProductListPresenter(wireFrame: wireframe, view: mockView , interactor: mockInteractor)

        presenter.viewDidLoad()

        XCTAssertTrue(mockInteractor.loadProductListCalled)

        presenter.didFailLoading(with: NSError(domain: "", code: 0, userInfo:nil))

        guard case ProductListViewState.error(_) = mockView.state else {
            XCTFail()
            return
        }

        presenter.didFinishLoading(products: [])

        guard case ProductListViewState.success(let products) = mockView.state else {
            XCTFail()
            return
        }

        XCTAssertEqual(products.count, 0)

        let selectedProduct = Product()
        presenter.viewDidSelect(item: selectedProduct)

        guard case ProductListWireframeNavigation.productDetail(let navigationProduct)? = wireframe.navigateOption else {
            XCTFail()
            return
        }

        XCTAssertEqual(selectedProduct.id, navigationProduct.id)
    }

    func testProductListInteractor() {

        let exp = expectation(description: "")

        let interactor = ProductListInteractor()
        let mockPresenter = MockProductListPresenter(interactor: interactor, expectation: exp)

        interactor.output = mockPresenter

        /// test successfull load

        let responseStub = URLResponseStub(statusCode: 200, headers: [:], payloadFileName: "productList.json")

        let mockSession = TestURLSession(stubResponse: responseStub)

        Network.Webservices.add(baseURL: DishwashersAPI.baseURL, authorizationHandler: nil, defaultHeaders: nil, session: mockSession)
        

        interactor.loadProductList()

        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertEqual(mockPresenter.products.count, 20)
        }
    }

    func testProductListInteractorFail() {

        let exp = expectation(description: "")

        let interactor = ProductListInteractor()
        let mockPresenter = MockProductListPresenter(interactor: interactor, expectation: exp)

        interactor.output = mockPresenter

        let jsonString =
        """
        {}
"""

        /// test fail

        let mockSession = TestURLSession(stubResponse: URLResponseStub(jsonString: jsonString))

        Network.Webservices.add(baseURL: DishwashersAPI.baseURL, authorizationHandler: nil, defaultHeaders: nil, session: mockSession)


        interactor.loadProductList()

        waitForExpectations(timeout: 5.0) { (_) in
            XCTAssertNotNil(mockPresenter.error)
        }
    }
    
}


private extension Product {
    init() {
        self.id = ""
        self.imageURL = ""
        self.title = ""
        self.price = ProductPrice(was: "", then1: "", then2: "", now: "", currency: "")
    }
}

class MockProductListView: ProductListViewInterface {
    private(set) var state: ProductListViewState = .loading

    func update(state: ProductListViewState) {
        self.state = state
    }
}

class MockProductListInteractor: ProductListInteractorInput {
    private(set) var loadProductListCalled: Bool = false

    func loadProductList() {
        loadProductListCalled = true
    }
}

class MockProductListPresenter: ProductListInteractorOutput {

    private(set) var products = [Product]()
    private(set) var error: Error?
    private(set) var expectation: XCTestExpectation
    var interactor: ProductListInteractorInput

    init(interactor: ProductListInteractorInput, expectation: XCTestExpectation) {
        self.expectation = expectation
        self.interactor = interactor
    }

    func didFinishLoading(products: [Product]) {
        self.products = products
        expectation.fulfill()
    }

    func didFailLoading(with error: Error) {
        self.error = error
        expectation.fulfill()
    }
}

class MockProductListWireframe: ProductListWireframeInterface {
    private(set) var navigateOption: ProductListWireframeNavigation!

    func navigate(to option: ProductListWireframeNavigation) {
        navigateOption = option
    }
}
