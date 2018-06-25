//
//  ProductListViewController.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

enum ProductListViewState {
    case loading
    case error(message: String)
    case success(results: Int, models: [ProductListCollectionViewCellModel])
}

protocol ProductListViewInterface: class {
    func update(state: ProductListViewState)
}

class ProductListViewController: UIViewController {

    private let columnCount = 4
    private let itemSpacing: CGFloat = 1.0
    private let itemHeightRatio: CGFloat = 1.3

    var presenter: ProductListPresenterInput?

    private var models = [ProductListCollectionViewCellModel]()
    private var results: Int = 0 {
        didSet {
            self.title = "Dishwashers (\(self.results))"
        }
    }

    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical

        let view = UICollectionView(frame: .zero, collectionViewLayout: flow)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupView()

        presenter?.viewDidLoad()
    }

    private func setupView() {

        view.addSubview(collectionView)
        collectionView.registerNibs(nibs: [ProductListCollectionViewCell.self])
        NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor)
            ])

        view.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 50.0),
            indicator.heightAnchor.constraint(equalToConstant: 50.0),
            indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])

    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] (_) in
            self?.collectionView.collectionViewLayout.invalidateLayout()
            }, completion: nil)
    }
}

extension ProductListViewController: ProductListViewInterface {
    func update(state: ProductListViewState) {

        indicator.stopAnimating()

        switch state {
        case .loading:
            self.indicator.startAnimating()
        case .error(let message):
                print(message)
        case .success(let results, let models):
            self.models = models
            self.results = results
            collectionView.reloadData()
        }
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.viewDidSelectItem(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.bounds.width - (CGFloat(columnCount - 1) * itemSpacing)) / CGFloat(columnCount)
        let height = width * itemHeightRatio
        return CGSize(width: width, height: height)
    }
}

extension ProductListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(atIndexPath: indexPath) as ProductListCollectionViewCell
        cell.configure(with: models[indexPath.item] )
        return cell
    }
}
