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

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProductParsing() {


        let jsonData = """
        {
              "productId": "3215462",
              "type": "product",
              "title": "Bosch SMS25AW00G Freestanding Dishwasher, White",
              "code": "81701107",
              "averageRating": 4.4722,
              "reviews": 72,
              "price": {
                "was": "",
                "then1": "",
                "then2": "",
                "now": "349.00",
                "uom": "",
                "currency": "GBP"
              },
              "image": "//johnlewis.scene7.com/is/image/JohnLewis/236888507?",
              "additionalServices": [
                "2 year guarantee included",
                "5 years Added Care for your home appliance (includes guarantee period) £100.00"
              ],
              "displaySpecialOffer": "",
              "promoMessages": {
                "priceMatched": "",
                "offer": "",
                "customPromotionalMessage": "",
                "bundleHeadline": "",
                "customSpecialOffer": {}
              }
        }
        """


        guard let productListData = jsonData.data(using: .utf8) else {
            XCTFail("product list is nil")
            return
        }

        let decoder = JSONDecoder()

        var product: Product?

        do {
            product = try decoder.decode(Product.self, from: productListData)
        } catch {
            XCTFail(error.localizedDescription)
            print(error)
        }

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
