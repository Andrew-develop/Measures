//
//  AddPhotoRouter.swift
//  Shapely
//
//  Created by Andrew on 13.03.2023.
//

import UIKit

protocol AddPhotoPublicRouter: AnyObject {
    func runScreenFactory(_ image: UIImage)
}

protocol AddPhotoInternalRouter: AnyObject {
    func pop()
}

final class AddPhotoRouter {
    private let factory: AddPhotoViewFactory
    private let appRouter: AppRouter

    init(factory: AddPhotoViewFactory,
         appRouter: AppRouter) {
        self.factory = factory
        self.appRouter = appRouter
    }
}

extension AddPhotoRouter: AddPhotoPublicRouter {
    func runScreenFactory(_ image: UIImage) {
        let controller = factory.createViewController(image)
        appRouter.push(controller, animated: false)
    }
}

extension AddPhotoRouter: AddPhotoInternalRouter {
    func pop() {
        appRouter.popModule()
    }
}
