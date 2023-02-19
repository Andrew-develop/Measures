//
//  ActivityLevelRouter.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

protocol ActivityLevelPublicRouter: AnyObject {
    func runScreenFactory()
}

protocol ActivityLevelInternalRouter: AnyObject {
    func dismiss()
}

final class ActivityLevelRouter {
    private let factory: ActivityLevelViewFactory
    private let appRouter: AppRouter

    init(factory: ActivityLevelViewFactory,
         appRouter: AppRouter) {
        self.factory = factory
        self.appRouter = appRouter
    }
}

extension ActivityLevelRouter: ActivityLevelPublicRouter {
    func runScreenFactory() {
        appRouter.present(factory.createViewController(), animated: true)
    }
}

extension ActivityLevelRouter: ActivityLevelInternalRouter {
    func dismiss() {
        appRouter.dismissModule(animated: true, completion: nil)
    }
}
