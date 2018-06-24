//
//  ProductListModuleTests.swift
//  DishwashersTests
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import XCTest
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

class MockProductListWireframe: ProductListWireframeInterface {
    private(set) var navigateOption: ProductListWireframeNavigation!

    func navigate(to option: ProductListWireframeNavigation) {
        navigateOption = option
    }
}
