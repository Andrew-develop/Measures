//
//  ChartRouter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

protocol ChartPublicRouter: AnyObject {
    func runScreenFactory()
}

protocol ChartInternalRouter: AnyObject {
    func pop()
}

final class ChartRouter {
    private let factory: ChartViewFactory
    private let appRouter: AppRouter

    init(factory: ChartViewFactory, appRouter: AppRouter) {
        self.factory = factory
        self.appRouter = appRouter
    }
}

extension ChartRouter: ChartPublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.push(controller, animated: true)
    }
}

extension ChartRouter: ChartInternalRouter {
    func pop() {
        appRouter.popModule()
    }
}
