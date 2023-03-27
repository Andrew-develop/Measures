//
//  LaunchRouter.swift
//  Shapely
//
//  Created by Andrew on 12.02.2023.
//

protocol LaunchPublicRouter: AnyObject {}

protocol LaunchInternalRouter: AnyObject {
    func runInitialStartScreen()
    func runMainScreen()
}

final class LaunchRouter {
    private let factory: LaunchViewFactory
    private let initialStartRouter: InitialStartPublicRouter
    private let mainRouter: MainBarPublicRouter

    init(factory: LaunchViewFactory,
         initialStartRouter: InitialStartPublicRouter,
         mainRouter: MainBarPublicRouter) {
        self.factory = factory
        self.initialStartRouter = initialStartRouter
        self.mainRouter = mainRouter
    }
}

extension LaunchRouter: LaunchPublicRouter {}

extension LaunchRouter: LaunchInternalRouter {
    func runInitialStartScreen() {
        initialStartRouter.runScreenFactory()
    }

    func runMainScreen() {
        mainRouter.runScreenFactory()
    }
}
