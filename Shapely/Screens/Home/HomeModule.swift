//
//  HomeModule.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import Swinject
import SwinjectAutoregistration

protocol HomeViewFactory {
    func createViewController() -> HomeViewController
}

final class HomeModule: AppModule, Assembly {
    private var resolver: Resolver!

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(HomeServiceProviderImpl.self, initializer: HomeServiceProviderImpl.init)
            .implements(HomeServiceProvider.self)

        container.autoregister(HomeRouter.self, initializer: HomeRouter.init)
            .implements(HomePublicRouter.self, HomeInternalRouter.self)
            .inObjectScope(.container)

        container.autoregister(HomeTableAdapter.self, initializer: HomeTableAdapter.init)

        container.register(HomeViewController.self) { resolver in
            let viewController = HomeViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(HomePresenter.self)!)
            return viewController
        }

        container.autoregister(HomePresenter.self, initializer: HomePresenter.init)

        container.register(HomeViewFactory.self) { _ in
            return self
        }
    }
}

extension HomeModule: HomeViewFactory {
    func createViewController() -> HomeViewController {
        return resolver.resolve(HomeViewController.self)!
    }
}
