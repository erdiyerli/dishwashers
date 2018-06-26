//
//  ProductDetailViewController.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 25/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

enum ProductDetailViewSection {
    case media(media: ProductMedia)
    case offers(price: ProductPrice, specialOffer: String, includedServices: [String] )
    case productInformation(information: String, productCode: String)
    case productSpecification(features: [ProductFeature])
    case readMore

    var headerTitle: String {
        switch self {
        case .productInformation(_, _):
            return "Product information"
        case .productSpecification(_):
            return "Product specification"
        default: return ""
        }
    }
}

private extension ProductDetailViewSection {
    var itemHeight: CGFloat {
        switch self {
        case .media(_): return 400.0
        case .offers(_,_,_): return 150.0
        case .readMore: return 100.0
        case .productSpecification(_): return 40.0
        case .productInformation(_,_): return 200.0
        }
    }

    func sectionBottomInset(for orientaiton: UIDeviceOrientation) -> CGFloat {
        switch self {
        case .media(_):
            return 0.0
        case .offers(_,_,_):
            return orientaiton.isPortrait ? 20.0 : 0.0
        case .readMore:
            return 20.0
        case .productSpecification(_):
            return 30.0
        case .productInformation(_,_):
            return orientaiton.isPortrait ? 80.0 : 20.0
        }
    }

    func sectionTopInset(for orientaiton: UIDeviceOrientation) -> CGFloat {
        switch self {
        case .offers(_,_,_):
            return 20.0
        default: return 0.0
        }
    }

    func headerReferenceHeight( for orientation: UIDeviceOrientation) -> CGFloat {
        switch self {
        case .offers(_,_,_):
            return orientation.isLandscape ? 0.0 : 10.0
        default:
            return 70.0
        }
    }
}

struct ProductDetailViewModel {
    private(set)var masterSections = [ProductDetailViewSection]()
    private(set)var detailSections = [ProductDetailViewSection]()
}

protocol ProductDetailViewInterface: class {
    func update(state: ViewState<ProductDetailViewModel>)
}

class ProductDetailViewController: UIViewController {
    var presenter: ProductDetailPresenterInterface?

    private var model: ProductDetailViewModel? {
        didSet {
            masterDataSource.sections = model?.masterSections ?? []
            detailDataSource.sections = model?.detailSections ?? []

            masterCollectionView.reloadData()
            detailCollectionView.reloadData()
        }
    }

    @IBOutlet private weak var masterCollectionView: UICollectionView! {
        didSet {
            masterCollectionView.delegate = self
            masterCollectionView.dataSource = masterDataSource
            masterCollectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
            (masterCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: masterCollectionView.bounds.width - (ProductDetailColelctionViewDataSource.horizontalInset * 2.0), height: 1.0)
        }
    }

    @IBOutlet private weak var detailCollectionView: UICollectionView! {
        didSet {
            detailCollectionView.delegate = self
            detailCollectionView.dataSource = detailDataSource
            detailCollectionView.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
            (detailCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: detailCollectionView.bounds.width - (ProductDetailColelctionViewDataSource.horizontalInset * 2.0), height: 1.0)
        }
    }

    private lazy  var masterDataSource: ProductDetailColelctionViewDataSource = {
        return ProductDetailColelctionViewDataSource(collectionView: masterCollectionView, sections: [])
    }()

    private lazy var detailDataSource: ProductDetailColelctionViewDataSource = {
        return ProductDetailColelctionViewDataSource(collectionView: detailCollectionView, sections: [])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .groupTableViewBackground

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "❮", style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem?.tintColor = .darkGray

        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        masterCollectionView.collectionViewLayout.invalidateLayout()
        detailCollectionView.collectionViewLayout.invalidateLayout()
    }

    override var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
            return UITraitCollection(traitsFrom: [
                UITraitCollection.init(horizontalSizeClass: .compact),
                UITraitCollection.init(verticalSizeClass: .regular)
                ])
        }
        return super.traitCollection
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        presenter?.viewOrientationDidChange(orientation: UIDevice.current.orientation)

        coordinator.animate(alongsideTransition: { (_) in
            self.masterCollectionView.collectionViewLayout.invalidateLayout()
            self.detailCollectionView.collectionViewLayout.invalidateLayout()
            self.masterCollectionView.layoutIfNeeded()
            self.detailCollectionView.layoutIfNeeded()
        }, completion: nil)
    }

    @IBAction private func backButtonTapped() {
        presenter?.viewDidTapBackButton()
    }
}

extension ProductDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let dataSource = collectionView.dataSource as? ProductDetailColelctionViewDataSource else {return .zero}

        let top = dataSource.sections[section].sectionTopInset(for: UIDevice.current.orientation)
        let bottom = dataSource.sections[section].sectionBottomInset(for: UIDevice.current.orientation)

        let defaultInset = UIEdgeInsets(top: top,
                                        left: ProductDetailColelctionViewDataSource.horizontalInset,
                                        bottom: bottom,
                                        right: ProductDetailColelctionViewDataSource.horizontalInset)
        return defaultInset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        guard let dataSource = collectionView.dataSource as? ProductDetailColelctionViewDataSource else {return .zero}

        return CGSize(width: collectionView.bounds.width - (ProductDetailColelctionViewDataSource.horizontalInset * 2.0),
                      height: dataSource.sections[section].headerReferenceHeight(for: UIDevice.current.orientation))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         guard let dataSource = collectionView.dataSource as? ProductDetailColelctionViewDataSource else {return .zero}

        return CGSize(width: collectionView.bounds.width - (ProductDetailColelctionViewDataSource.horizontalInset * 2.0),
                      height: dataSource.sections[indexPath.section].itemHeight)
    }

}

extension ProductDetailViewController: ProductDetailViewInterface {
    func update(state: ViewState<ProductDetailViewModel>) {
        switch state {
        case .success(let model):
            self.model = model
        default: break
        }
    }
}
