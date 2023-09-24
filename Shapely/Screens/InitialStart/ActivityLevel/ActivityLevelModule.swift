//
//  ActivityLevelModule.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import Swinject
import SwinjectAutoregistration

protocol ActivityLevelViewFactory {
    func createViewController() -> ActivityLevelViewController
}

final class ActivityLevelModule: AppModule, Assembly {
    private var resolver: Resolver!

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(ActivityLevelServiceProviderImpl.self,
                               initializer: ActivityLevelServiceProviderImpl.init)
            .implements(ActivityLevelServiceProvider.self)
            .inObjectScope(.container)

        container.autoregister(ActivityLevelRouter.self, initializer: ActivityLevelRouter.init)
            .implements(ActivityLevelPublicRouter.self, ActivityLevelInternalRouter.self)
            .inObjectScope(.container)

        container.autoregister(ActivityLevelTableAdapter.self, initializer: ActivityLevelTableAdapter.init)

        container.register(ActivityLevelViewController.self) { resolver in
            let viewController = ActivityLevelViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(ActivityLevelPresenter.self)!)
            return viewController
        }

        container.autoregister(ActivityLevelPresenter.self, initializer: ActivityLevelPresenter.init)

        container.register(ActivityLevelViewFactory.self) { _ in
            return self
        }
    }
}

extension ActivityLevelModule: ActivityLevelViewFactory {
    func createViewController() -> ActivityLevelViewController {
        return resolver.resolve(ActivityLevelViewController.self)!
    }
}
