//
//  CalorieIntakeRouter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

protocol CalorieIntakePublicRouter: AnyObject {
    func runScreenFactory()
}

protocol CalorieIntakeInternalRouter: AnyObject {
    func runParametersScreen()
    func runActivityLevelScreen()
    func runPersonalInfoScreen()
}

final class CalorieIntakeRouter {
    private let factory: CalorieIntakeViewFactory
    private let appRouter: AppRouter
    private let parametersRouter: ParametersPublicRouter
    private let activityLevelRouter: ActivityLevelPublicRouter
    weak var personalInfoRouter: PersonalInfoPublicRouter?

    init(factory: CalorieIntakeViewFactory,
         appRouter: AppRouter,
         parametersRouter: ParametersPublicRouter,
         activityLevelRouter: ActivityLevelPublicRouter) {
        self.factory = factory
        self.appRouter = appRouter
        self.parametersRouter = parametersRouter
        self.activityLevelRouter = activityLevelRouter
    }
}

extension CalorieIntakeRouter: CalorieIntakePublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.setRootModule(controller, animated: false)
    }
}

extension CalorieIntakeRouter: CalorieIntakeInternalRouter {
    func runParametersScreen() {
        parametersRouter.runScreenFactory()
    }

    func runActivityLevelScreen() {
        activityLevelRouter.runScreenFactory()
    }

    func runPersonalInfoScreen() {
        personalInfoRouter?.runScreenFactory()
    }
}
