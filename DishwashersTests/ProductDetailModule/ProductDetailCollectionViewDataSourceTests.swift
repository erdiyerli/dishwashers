//
//  ProductDetailCollectionViewDataSourceTests.swift
//  DishwashersTests
//
//  Created by Erdi Yerli on 26/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import XCTest
@testable import Dishwashers

class ProductDetailCollectionViewDataSourceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testNumberOfSections() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        let dataSource = ProductDetailColelctionViewDataSource(collectionView: collectionView, sections: [])

        XCTAssertEqual(dataSource.numberOfSections(in: collectionView), 0)

        dataSource.sections = [.productInformation(information: "", productCode: ""), .readMore]

        XCTAssertEqual(dataSource.numberOfSections(in: collectionView), 2)
    }

    func testNumberOfItemsInSection() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        let dataSource = ProductDetailColelctionViewDataSource(collectionView: collectionView, sections: [])

        let features = ProductFeature(attributes: [
            ProductFeatureAttribute(name: "", value: ""),
            ProductFeatureAttribute(name: "", value: ""),
            ProductFeatureAttribute(name: "", value: "")
            ])

        let price = ProductPrice(was: "", then1: "", then2: "", now: "", currency: "")
        let media = ProductMedia(altText: "", urls: [])

        dataSource.sections = [
            .media(media: media),
            .offers(price: price , specialOffer: "", includedServices: []),
            .productInformation(information: "", productCode: ""),
            .readMore,
            .productSpecification(features: [features])
        ]

        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 0), 1)
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 1), 1)
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 2), 1)
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 3), 1)
        XCTAssertEqual(dataSource.collectionView(collectionView, numberOfItemsInSection: 4), 3)
    }

    func testCellAtIndexPath() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        let dataSource = ProductDetailColelctionViewDataSource(collectionView: collectionView, sections: [])

        let features = ProductFeature(attributes: [
            ProductFeatureAttribute(name: "", value: "")
            ])
        let price = ProductPrice(was: "", then1: "", then2: "", now: "", currency: "")
        let media = ProductMedia(altText: "", urls: [])

        dataSource.sections = [
            .media(media: media),
            .offers(price: price , specialOffer: "", includedServices: []),
            .productInformation(information: "", productCode: ""),
            .readMore,
            .productSpecification(features: [features])
        ]

        collectionView.registerNibs(nibs: [
            ProductInformationCollectionViewCell.self,
            ProductDetailSpecificationCollectionViewCell.self,
            ProductDetailReadMoreCollectionViewCell.self,
            ProductDetailPriceCollectionViewCell.self,
            MediaImageViewerCollectionViewCell.self
            ])

        collectionView.dataSource = dataSource
        collectionView.reloadData()

        let mediaCell = dataSource.collectionView(collectionView, cellForItemAt: IndexPath.init(item: 0, section: 0))
        let offerCell = dataSource.collectionView(collectionView, cellForItemAt: IndexPath.init(item: 0, section: 1))
        let infoCell = dataSource.collectionView(collectionView, cellForItemAt: IndexPath.init(item: 0, section: 2))
        let readMoreCell = dataSource.collectionView(collectionView, cellForItemAt: IndexPath.init(item: 0, section: 3))
        let specificationCell = dataSource.collectionView(collectionView, cellForItemAt: IndexPath.init(item: 0, section: 4))


        XCTAssert(mediaCell is MediaImageViewerCollectionViewCell)
        XCTAssert(offerCell is ProductDetailPriceCollectionViewCell)
        XCTAssert(infoCell is ProductInformationCollectionViewCell)
        XCTAssert(readMoreCell is ProductDetailReadMoreCollectionViewCell)
        XCTAssert(specificationCell is ProductDetailSpecificationCollectionViewCell)
    }
    
}
