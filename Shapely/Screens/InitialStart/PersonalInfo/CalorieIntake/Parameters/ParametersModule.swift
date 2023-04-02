//
//  ParametersModule.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import Swinject
import SwinjectAutoregistration

protocol ParametersViewFactory {
    func createViewController() -> ParametersViewController
}

final class ParametersModule: AppModule, Assembly {
    private var resolver: Resolver!

    var submodules: [AppModule] = [
        FinishModule()
    ]

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(ParametersRouter.self, initializer: ParametersRouter.init)
            .implements(ParametersPublicRouter.self, ParametersInternalRouter.self)
            .inObjectScope(.container)
            .initCompleted { resolver, router in
                router.calorieIntakeRouter = resolver.resolve()
            }

        container.autoregister(ParametersTableAdapter.self, initializer: ParametersTableAdapter.init)

        container.register(ParametersViewController.self) { resolver in
            let viewController = ParametersViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(ParametersPresenter.self)!)
            return viewController
        }

        container.autoregister(ParametersPresenter.self, initializer: ParametersPresenter.init)

        container.register(ParametersViewFactory.self) { _ in
            return self
        }
    }
}

extension ParametersModule: ParametersViewFactory {
    func createViewController() -> ParametersViewController {
        return resolver.resolve(ParametersViewController.self)!
    }
}
