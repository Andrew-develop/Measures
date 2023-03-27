//
//  PhotoCollageRouter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

protocol PhotoCollagePublicRouter: AnyObject {}

protocol PhotoCollageInternalRouter: AnyObject {
    func runAddPhotoScreen()
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
    func runAddPhotoScreen() {
        addPhotoRouter.runScreenFactory()
    }
}
