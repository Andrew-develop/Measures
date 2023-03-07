//
//  HomeRouter.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

protocol HomePublicRouter: AnyObject {
    func runScreenFactory()
}

protocol HomeInternalRouter: AnyObject {}

final class HomeRouter {
    private let factory: HomeViewFactory
    private let appRouter: AppRouter

    init(factory: HomeViewFactory,
         appRouter: AppRouter) {
        self.factory = factory
        self.appRouter = appRouter
    }
}

extension HomeRouter: HomePublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.setRootModule(controller, animated: true)
    }
}

extension HomeRouter: HomeInternalRouter {}
