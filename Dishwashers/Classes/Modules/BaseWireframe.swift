//
//  BaseWireframe.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

protocol WireframeInterface: class {
    func popFromNavigationController(animated: Bool)
    func dismiss(animated: Bool, completion: (()-> Void)?)
}

class BaseWireframe {

    unowned var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func show(_ controller: UIViewController, with transition: Transition, animated: Bool) {
        switch transition {
        case .root:
            navigationController.setViewControllers([controller], animated: animated)
        case .push:
            navigationController.pushViewController(controller, animated: animated)
        case .present(let presentingController):
            navigationController.viewControllers = [controller]
            presentingController.present(navigationController, animated: animated, completion: nil)
        }
    }
}

extension BaseWireframe: WireframeInterface {
    func popFromNavigationController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    func dismiss(animated: Bool, completion: (()-> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
}


