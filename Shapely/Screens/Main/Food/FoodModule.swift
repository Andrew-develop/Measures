//
//  FoodModule.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import Swinject
import SwinjectAutoregistration

protocol FoodViewFactory {
    func createViewController() -> FoodViewController
}

final class FoodModule: AppModule, Assembly {
    private var resolver: Resolver!

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(FoodServiceProviderImpl.self, initializer: FoodServiceProviderImpl.init)
            .implements(FoodServiceProvider.self)

        container.autoregister(FoodRouter.self, initializer: FoodRouter.init)
            .implements(FoodPublicRouter.self, FoodInternalRouter.self)
            .inObjectScope(.container)

        container.autoregister(FoodTableAdapter.self, initializer: FoodTableAdapter.init)

        container.register(FoodViewController.self) { resolver in
            let viewController = FoodViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(FoodPresenter.self)!)
            return viewController
        }

        container.autoregister(FoodPresenter.self, initializer: FoodPresenter.init)

        container.register(FoodViewFactory.self) { _ in
            return self
        }
    }
}

extension FoodModule: FoodViewFactory {
    func createViewController() -> FoodViewController {
        return resolver.resolve(FoodViewController.self)!
    }
}
