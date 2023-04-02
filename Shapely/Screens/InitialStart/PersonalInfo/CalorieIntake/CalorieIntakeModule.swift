//
//  CalorieIntakeModule.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import Swinject
import SwinjectAutoregistration

protocol CalorieIntakeViewFactory {
    func createViewController() -> CalorieIntakeViewController
}

final class CalorieIntakeModule: AppModule, Assembly {
    private var resolver: Resolver!

    var submodules: [AppModule] = [
        ParametersModule(),
        ActivityLevelModule()
    ]

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(CalorieIntakeServiceProviderImpl.self,
                               initializer: CalorieIntakeServiceProviderImpl.init)
            .implements(CalorieIntakeServiceProvider.self)

        container.autoregister(CalorieIntakeRouter.self, initializer: CalorieIntakeRouter.init)
            .implements(CalorieIntakePublicRouter.self, CalorieIntakeInternalRouter.self)
            .inObjectScope(.container)
            .initCompleted { resolver, router in
                router.personalInfoRouter = resolver.resolve()
            }

        container.autoregister(CalorieIntakeTableAdapter.self, initializer: CalorieIntakeTableAdapter.init)

        container.register(CalorieIntakeViewController.self) { resolver in
            let viewController = CalorieIntakeViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(CalorieIntakePresenter.self)!)
            return viewController
        }

        container.autoregister(CalorieIntakePresenter.self, initializer: CalorieIntakePresenter.init)

        container.register(CalorieIntakeViewFactory.self) { _ in
            return self
        }
    }
}

extension CalorieIntakeModule: CalorieIntakeViewFactory {
    func createViewController() -> CalorieIntakeViewController {
        return resolver.resolve(CalorieIntakeViewController.self)!
    }
}
