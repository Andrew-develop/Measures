//
//  LaunchRouter.swift
//  Shapely
//
//  Created by Andrew on 12.02.2023.
//

protocol LaunchPublicRouter: AnyObject {}

protocol LaunchInternalRouter: AnyObject {
    func runInitialStartScreen()
    func runHomeScreen()
}

final class LaunchRouter {
    private let factory: LaunchViewFactory
    private let initialStartRouter: InitialStartPublicRouter
    private let homeRouter: HomePublicRouter

    init(factory: LaunchViewFactory,
         initialStartRouter: InitialStartPublicRouter,
         homeRouter: HomePublicRouter) {
        self.factory = factory
        self.initialStartRouter = initialStartRouter
        self.homeRouter = homeRouter
    }
}

extension LaunchRouter: LaunchPublicRouter {}

extension LaunchRouter: LaunchInternalRouter {
    func runInitialStartScreen() {
        initialStartRouter.runScreenFactory()
    }

    func runHomeScreen() {
        homeRouter.runScreenFactory()
    }
}
