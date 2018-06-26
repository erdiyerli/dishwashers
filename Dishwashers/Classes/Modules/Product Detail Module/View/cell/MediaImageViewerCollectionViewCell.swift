//
//  MediaImageViewerCollectionViewCell.swift
//  Dishwashers
//
//  Created by Erdi Yerli on 26/06/2018.
//  Copyright © 2018 doubletap. All rights reserved.
//

import UIKit

class MediaImageViewerCollectionViewCell: DynamicSizeCollectionViewCell {

    @IBOutlet private weak var viewer: MediaImageViewer!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(images: [String]) {
        viewer.images = images
    }

}
