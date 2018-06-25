//
//  ProductDetailViewController.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 25/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit


protocol ProductDetailViewInterface: class {
    func update(state: ViewState<Any>)
}

class ProductDetailViewController: UIViewController {
    var presenter: ProductDetailPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.groupTableViewBackground
        presenter?.viewDidLoad()
    }
}

extension ProductDetailViewController: ProductDetailViewInterface {
    func update(state: ViewState<Any>) {
        switch state {
        default: break
        }
    }
}
