//
//  InitialStartRouter.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import UIKit

protocol InitialStartPublicRouter: AnyObject {
    func runScreenFactory()
}

protocol InitialStartInternalRouter: AnyObject {
    func runActionSheet(with controller: UIAlertController)
    func runActivityLevelScreen()
}

final class InitialStartRouter {
    private let factory: InitialStartViewFactory
    private let activityLevelRouter: ActivityLevelPublicRouter
    private let appRouter: AppRouter

    init(factory: InitialStartViewFactory,
         activityLevelRouter: ActivityLevelPublicRouter,
         appRouter: AppRouter) {
        self.factory = factory
        self.activityLevelRouter = activityLevelRouter
        self.appRouter = appRouter
    }
}

extension InitialStartRouter: InitialStartPublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.setRootModule(controller, animated: true)
    }
}

extension InitialStartRouter: InitialStartInternalRouter {
    func runActionSheet(with controller: UIAlertController) {
        appRouter.present(controller, animated: true)
    }

    func runActivityLevelScreen() {
        activityLevelRouter.runScreenFactory()
    }
}
