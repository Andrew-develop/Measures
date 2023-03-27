//
//  MainBarRouter.swift
//  Vladlink
//
//  Created by Pavel on 13/03/2021.
//  Copyright © 2021 Vladlink. All rights reserved.
//

protocol MainBarPublicRouter: AnyObject {
    func runScreenFactory()
}

protocol MainBarInternalRouter: AnyObject {}

final class MainBarRouter {
    // MARK: - Properties

    private let factory: MainBarViewFactory
    private let appRouter: AppRouterImp

    // MARK: - Lifecycle

    init(factory: MainBarViewFactory,
         appRouter: AppRouterImp) {
        self.factory = factory
        self.appRouter = appRouter
    }
}

// MARK: - MainBarPublicRouter

extension MainBarRouter: MainBarPublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.setRootModule(controller, animated: false)
    }
}

// MARK: - MainBarInternalRouter

extension MainBarRouter: MainBarInternalRouter {}
