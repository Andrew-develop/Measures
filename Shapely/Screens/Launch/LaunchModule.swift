//
//  LaunchModule.swift
//  Shapely
//
//  Created by Andrew on 12.02.2023.
//

import Swinject
import SwinjectAutoregistration

protocol LaunchViewFactory {
    func createViewController() -> LaunchViewController
}

final class LaunchModule: AppModule, Assembly {
    private var resolver: Resolver!

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(LaunchServiceProviderImpl.self, initializer: LaunchServiceProviderImpl.init)
            .implements(LaunchServiceProvider.self)

        container.autoregister(LaunchRouter.self, initializer: LaunchRouter.init)
            .implements(LaunchPublicRouter.self, LaunchInternalRouter.self)
            .inObjectScope(.container)

        container.register(LaunchViewController.self) { resolver in
            let viewController = LaunchViewController()
            viewController.bind(to: resolver.resolve(LaunchPresenter.self)!)
            return viewController
        }

        container.autoregister(LaunchPresenter.self, initializer: LaunchPresenter.init)

        container.register(LaunchViewFactory.self) { _ in
            return self
        }
    }
}

extension LaunchModule: LaunchViewFactory {
    func createViewController() -> LaunchViewController {
        return resolver.resolve(LaunchViewController.self)!
    }
}
