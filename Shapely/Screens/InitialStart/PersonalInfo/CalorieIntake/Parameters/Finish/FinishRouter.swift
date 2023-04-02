//
//  FinishRouter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

protocol FinishPublicRouter: AnyObject {
    func runScreenFactory()
}

protocol FinishInternalRouter: AnyObject {
    func runMainScreen()
    func runParametersScreen()
    func showDialog(_ dialog: DialogController)
}

final class FinishRouter {
    private let factory: FinishViewFactory
    private let appRouter: AppRouter
    private let mainRouter: MainBarPublicRouter
    weak var parametersRouter: ParametersPublicRouter?

    init(factory: FinishViewFactory,
         appRouter: AppRouter,
         mainRouter: MainBarPublicRouter) {
        self.factory = factory
        self.appRouter = appRouter
        self.mainRouter = mainRouter
    }
}

extension FinishRouter: FinishPublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.setRootModule(controller, animated: false)
    }
}

extension FinishRouter: FinishInternalRouter {
    func runMainScreen() {
        mainRouter.runScreenFactory()
    }

    func runParametersScreen() {
        parametersRouter?.runScreenFactory()
    }

    func showDialog(_ dialog: DialogController) {
        appRouter.present(dialog, animated: true)
    }
}
