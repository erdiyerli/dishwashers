//
//  ProductDetailModelTests.swift
//  DishwashersTests
//
//  Created by Erdi Yerli on 23/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import XCTest
@testable import Dishwashers

class ProductDetailModelTests: XCTestCase {

    private let bundle = Bundle(for: ProductDetailModelTests.self)
    private var productDetailData: Data?

    override func setUp() {
        super.setUp()

        guard let url = bundle.url(forResource: "productDetail", withExtension: "json") else {
            XCTFail()
            return
        }

        do {
            productDetailData = try Data.init(contentsOf: url)
        } catch {
            print(error)
            XCTFail()
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testProductDetailParse() {

        guard let productDetailData = productDetailData  else {
            XCTFail()
            return
        }

        var productDetail: ProductDetail?

        do {
            let decoder = JSONDecoder()
            productDetail = try decoder.decode(ProductDetail.self, from: productDetailData)
        } catch {
            print(error)
            XCTFail(error.localizedDescription)
        }

        XCTAssertNotNil(productDetail)

        XCTAssertEqual(productDetail?.id, "3244905")
        XCTAssertEqual(productDetail?.title, "Neff S513K60X0G Integrated Dishwasher")
        XCTAssertEqual(productDetail?.code, "88701308")
        XCTAssertEqual(productDetail?.media.altText, "BuyNeff S513K60X0G Integrated Dishwasher Online at johnlewis.com")
        XCTAssertEqual(productDetail?.media.urls.count, 5)
        XCTAssertEqual(productDetail?.price.now, "429.00")
        XCTAssertEqual(productDetail?.productInformation, "<p>Equipped with a variety of advanced features inside a sleek, integrated design, the S513K60X0G dishwasher from Neff will make doing the dishes easier than ever.</p>\r\r<p><strong>Energy efficient</strong><br>\rAwarded an excellent A++ for energy efficiency, you can rely on the S513K60X0G to help you save on your energy bills while keeping a green home.</p>\r\r<p><strong>DosageAssist</strong><br>\rThis useful function makes sure your detergent is completely dissolved for a more effective wash by releasing it into a special tray on top of the basket and mixing it into the cycle.</p>\r\r<p><strong>AquaSensor</strong><br>\rSaving water and energy, this feature automatically assesses how much water is needed, even during the rinsing stage, and will only use what's necessary.</p>\r\r<p><strong>Flexible loading</strong><br>\rThe S513K60X0G offers total flexibility with Neff's Flex basket and Vario drawer system. The top basket can be adjusted between 3 height positions and contains 2 foldable plate racks and 2 foldable cup shelves. Similarly, the bottom basket holds 4 foldable plate racks, while the Vario drawer offers extra storage on a third level.</p>\r\r<p><strong>Additional features and programmes:</strong><br>\r<ul>\r<li>Chef 70°C pro programme</li>\r<li>Aqua Stop</li>\r<li>Vario Speed Plus</li>\r<li>InfoLight status projection</li>\r\r<li>Efficient Drive</li>\r<li>Detergent Aware</li></ul></p>\r\r")
        XCTAssertEqual(productDetail?.displaySpecialOffer, "Save £50 until 10.07.18 (price includes saving)")
        XCTAssertEqual(productDetail?.includedServices, ["2 year guarantee included"])
        XCTAssertEqual(productDetail?.features.count, 1)
        XCTAssertEqual(productDetail?.features.first?.attributes.count, 31)
        XCTAssertEqual(productDetail?.features.first?.attributes.first?.name, "Salt Level Indicator")
        XCTAssertEqual(productDetail?.features.first?.attributes.first?.value, "YES")

    }
}
