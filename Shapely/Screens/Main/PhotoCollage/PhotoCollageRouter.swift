//
//  PhotoCollageRouter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import UIKit

protocol PhotoCollagePublicRouter: AnyObject {}

protocol PhotoCollageInternalRouter: AnyObject {
    func runAddPhotoScreen(_ image: UIImage)
}

final class PhotoCollageRouter {
    private let factory: PhotoCollageViewFactory
    private let addPhotoRouter: AddPhotoPublicRouter

    init(factory: PhotoCollageViewFactory,
         addPhotoRouter: AddPhotoPublicRouter) {
        self.factory = factory
        self.addPhotoRouter = addPhotoRouter
    }
}

extension PhotoCollageRouter: PhotoCollagePublicRouter {}

extension PhotoCollageRouter: PhotoCollageInternalRouter {
    func runAddPhotoScreen(_ image: UIImage) {
        addPhotoRouter.runScreenFactory(image)
    }
}
