//
//  InitialStartRouter.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

protocol InitialStartPublicRouter: AnyObject {
    func runScreenFactory()
}

protocol InitialStartInternalRouter: AnyObject {
    func runPersonalInfoScreen()
}

final class InitialStartRouter {
    private let factory: InitialStartViewFactory
    private let appRouter: AppRouterImp

    init(factory: InitialStartViewFactory,
         appRouter: AppRouterImp) {
        self.factory = factory
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
    func runPersonalInfoScreen() {}
}
