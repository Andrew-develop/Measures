//
//  ParametersRouter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

protocol ParametersPublicRouter: AnyObject {
    func runScreenFactory()
}

protocol ParametersInternalRouter: AnyObject {
    func runFinishScreen()
    func runCalorieIntakeScreen()
}

final class ParametersRouter {
    private let factory: ParametersViewFactory
    private let appRouter: AppRouter
    private let finishRouter: FinishPublicRouter
    weak var calorieIntakeRouter: CalorieIntakePublicRouter?

    init(factory: ParametersViewFactory,
         appRouter: AppRouter,
         finishRouter: FinishPublicRouter) {
        self.factory = factory
        self.appRouter = appRouter
        self.finishRouter = finishRouter
    }
}

extension ParametersRouter: ParametersPublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.setRootModule(controller, animated: false)
    }
}

extension ParametersRouter: ParametersInternalRouter {
    func runFinishScreen() {
        finishRouter.runScreenFactory()
    }

    func runCalorieIntakeScreen() {
        calorieIntakeRouter?.runScreenFactory()
    }
}
