//
//  ProductModelTests.swift
//  DishwashersTests
//
//  Created by Erdi Yerli on 23/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import XCTest
@testable import Dishwashers

class ProductModelTests: XCTestCase {

    private let bundle = Bundle(for: ProductDetailModelTests.self)
    private var productListData: Data?

    override func setUp() {
        super.setUp()

        guard let url = bundle.url(forResource: "productList", withExtension: "json") else {
            XCTFail()
            return
        }

        do {
            productListData = try Data.init(contentsOf: url)
        } catch {
            print(error)
            XCTFail()
        }
    }

    override func tearDown() {
        super.tearDown()
    }

    func testProductParsing() {


        guard let data = productListData else {
            XCTFail("product list is nil")
            return
        }

        let decoder = JSONDecoder()

        var searchResult: SearchResult?

        do {
            searchResult = try decoder.decode(SearchResult.self, from: data)
        } catch {
            XCTFail(error.localizedDescription)
            print(error)
        }

        XCTAssertNotNil(searchResult)

        XCTAssertEqual(searchResult?.products.count, 20)
        XCTAssertEqual(searchResult?.results, 181)
        let product = searchResult?.products.first

        XCTAssertEqual(product?.id, "3215462")
        XCTAssertEqual(product?.title, "Bosch SMS25AW00G Freestanding Dishwasher, White")
        XCTAssertEqual(product?.image, "//johnlewis.scene7.com/is/image/JohnLewis/236888507?")
        XCTAssertEqual(product?.imageURL, URL(string: "https://johnlewis.scene7.com/is/image/JohnLewis/236888507?"))
        XCTAssertEqual(product?.price.was, "")
        XCTAssertEqual(product?.price.then1, "")
        XCTAssertEqual(product?.price.then2, "")
        XCTAssertEqual(product?.price.now, "349.00")
        XCTAssertEqual(product?.price.currency, "GBP")


    }

}
