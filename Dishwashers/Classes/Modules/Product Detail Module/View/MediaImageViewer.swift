//
//  MediaImageViewer.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 25/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit
import Base

class MediaImageViewer: UICollectionReusableView {

    var images = [String]() {
        didSet {
            createItems()
        }
    }

    private lazy var stackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private lazy var pageControl: UIPageControl = {
        let view = UIPageControl(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.currentPageIndicatorTintColor = .darkGray
        view.pageIndicatorTintColor = .lightGray
        return view
    }()

    init(images: [String]) {
        super.init(frame: .zero)
        self.images = images
        setupView()
        createItems()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {

        clipsToBounds = true

        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0)
            ])

        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])

        addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10.0),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
    }

    private func createItems() {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })

        images.compactMap({ URL(string: $0) }).forEach({ imageURL in
            let view = UIImageView(frame: .zero)
            view.contentMode = .scaleAspectFit
            view.kf.setImage(with: imageURL)
            stackView.addArrangedSubview(view)

            view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        })

        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
    }

}

extension MediaImageViewer: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / self.bounds.width)
        pageControl.currentPage = currentPage
    }
}
