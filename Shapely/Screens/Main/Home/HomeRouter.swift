//
//  HomeRouter.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

protocol HomePublicRouter: AnyObject {
    func runScreenFactory()
}

protocol HomeInternalRouter: AnyObject {
    func runChartScreen()
}

final class HomeRouter {
    private let factory: HomeViewFactory
    private let appRouter: AppRouter
    private let chartRouter: ChartPublicRouter

    init(factory: HomeViewFactory,
         appRouter: AppRouter,
         chartRouter: ChartPublicRouter) {
        self.factory = factory
        self.appRouter = appRouter
        self.chartRouter = chartRouter
    }
}

extension HomeRouter: HomePublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.setRootModule(controller, animated: true)
    }
}

extension HomeRouter: HomeInternalRouter {
    func runChartScreen() {
        chartRouter.runScreenFactory()
    }
}
