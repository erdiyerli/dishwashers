//
//  ProductDetailColelctionViewDataSource.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 26/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

private extension ProductDetailViewSection {
    var numberOfItems: Int {
        switch self {
        case .media(_), .offers(_), .productInformation(_,_), .readMore: return 1
        case .productSpecification(let features): return features.first?.attributes.count ?? 0
        }
    }
}

class ProductDetailColelctionViewDataSource: NSObject, UICollectionViewDataSource {

    static let horizontalInset: CGFloat = 50.0

    var sections: [ProductDetailViewSection]
    private var collectionView: UICollectionView



    private var mediaView: MediaImageViewer?

    init(collectionView: UICollectionView, sections: [ProductDetailViewSection]) {
        self.sections = sections
        self.collectionView = collectionView

        collectionView.registerNibs(nibs: [
            ProductInformationCollectionViewCell.self,
            ProductDetailSpecificationCollectionViewCell.self,
            ProductDetailReadMoreCollectionViewCell.self,
            ProductDetailPriceCollectionViewCell.self,
            MediaImageViewerCollectionViewCell.self
            ])

        collectionView.registerSupplementaryView(viewClass: UICollectionReusableView.self, ofKind: UICollectionElementKindSectionHeader)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let empty = collectionView.dequeueSupplementaryView(at: indexPath, ofKind: kind)
        empty.subviews.forEach({$0.removeFromSuperview()})
        empty.backgroundColor = .white
        
        let section = sections[indexPath.section]
        switch section {
        case .offers(_, _, _):
            empty.backgroundColor = .groupTableViewBackground

        case .productInformation(_,_), .productSpecification(_):

            let view = ProductDetailSectionHeaderView(frame: empty.bounds)
            view.title = section.headerTitle
            empty.addSubview(view)

            view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: empty.leftAnchor, constant: ProductDetailColelctionViewDataSource.horizontalInset),
            view.topAnchor.constraint(equalTo: empty.topAnchor),
            view.rightAnchor.constraint(equalTo: empty.rightAnchor),
            view.bottomAnchor.constraint(equalTo: empty.bottomAnchor)
            ])

        default:
            return empty
        }

        return empty
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]


        switch section {
        case .offers(let price, let specialOffer, let includedServices):
            let cell = collectionView.dequeueCell(atIndexPath: indexPath) as ProductDetailPriceCollectionViewCell
            cell.configure(with: price.now, specialOffer: specialOffer, includedServices: includedServices)
            return cell

        case .media(let media):
            let cell = collectionView.dequeueCell(atIndexPath: indexPath) as MediaImageViewerCollectionViewCell
            cell.configure(images: media.urls.compactMap({ "https:\($0)"}))
            return cell

        case .productInformation(let info, let productCode):
            let cell = collectionView.dequeueCell(atIndexPath: indexPath) as ProductInformationCollectionViewCell
            cell.configure(with: ProductInformationCollectionViewCellModel.init(information: info, productCode:productCode, landscape: UIDevice.current.orientation.isLandscape))
            return cell

        case .productSpecification(let features):
            let cell = collectionView.dequeueCell(atIndexPath: indexPath) as ProductDetailSpecificationCollectionViewCell
            cell.configure(with: features[0].attributes[indexPath.item] )
            return cell

        case .readMore:
            return collectionView.dequeueCell(atIndexPath: indexPath) as ProductDetailReadMoreCollectionViewCell
        }
    }
}
