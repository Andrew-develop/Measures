//
//  LaunchRouter.swift
//  Shapely
//
//  Created by Andrew on 12.02.2023.
//

protocol LaunchPublicRouter: AnyObject {}

protocol LaunchInternalRouter: AnyObject {
    func runInitialStartScreen()
}

final class LaunchRouter {
    private let factory: LaunchViewFactory
    private let initialStartRouter: InitialStartPublicRouter

    init(factory: LaunchViewFactory,
         initialStartRouter: InitialStartPublicRouter) {
        self.factory = factory
        self.initialStartRouter = initialStartRouter
    }
}

extension LaunchRouter: LaunchPublicRouter {}

extension LaunchRouter: LaunchInternalRouter {
    func runInitialStartScreen() {
        initialStartRouter.runScreenFactory()
    }
}
