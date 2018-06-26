//
//  CollectionView+Dishwashers.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 24/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerNibs<T: UICollectionViewCell>(nibs: [T.Type]) {
        for nib in nibs {
            self.register(UINib(nibName: String(describing: nib), bundle: nil), forCellWithReuseIdentifier: String(describing: nib))
        }
    }

    func dequeueCell<T>(atIndexPath indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    func registerClasses<T: UICollectionViewCell>(classes: [T.Type]) {
        for aClass in classes {
            self.register(aClass, forCellWithReuseIdentifier: String(describing: aClass.self))
        }
    }

    func registerSupplementaryView<T: UICollectionReusableView>(viewClass: T.Type, ofKind: String) {
        let id = String(describing: T.self)
        self.register(T.self, forSupplementaryViewOfKind: ofKind, withReuseIdentifier: id)
    }

    func dequeueSupplementaryView<T: UICollectionReusableView>(at indexPath: IndexPath, ofKind: String) -> T {
        let id = String(describing: T.self)
        guard let view = self.dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: id, for: indexPath) as? T else {
            fatalError()
        }
        return view
    }
}
