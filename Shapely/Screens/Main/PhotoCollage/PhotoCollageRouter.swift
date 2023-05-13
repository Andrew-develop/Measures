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
    func shareArchive(_ content: [Any], source: UIView, date: String)
}

final class PhotoCollageRouter {
    private let factory: PhotoCollageViewFactory
    private let appRouter: AppRouter
    private let addPhotoRouter: AddPhotoPublicRouter

    init(factory: PhotoCollageViewFactory,
         appRouter: AppRouter,
         addPhotoRouter: AddPhotoPublicRouter) {
        self.factory = factory
        self.appRouter = appRouter
        self.addPhotoRouter = addPhotoRouter
    }
}

extension PhotoCollageRouter: PhotoCollagePublicRouter {}

extension PhotoCollageRouter: PhotoCollageInternalRouter {
    func runAddPhotoScreen(_ image: UIImage) {
        addPhotoRouter.runScreenFactory(image)
    }

    func shareArchive(_ content: [Any], source: UIView, date: String) {
        let activityViewController = UIActivityViewController(activityItems: content, applicationActivities: nil)
        appRouter.present(activityViewController)
    }
}
