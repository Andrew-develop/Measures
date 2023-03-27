//
//  TrainingModule.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import Swinject
import SwinjectAutoregistration

protocol TrainingViewFactory {
    func createViewController() -> TrainingViewController
}

final class TrainingModule: AppModule, Assembly {
    private var resolver: Resolver!

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(TrainingServiceProviderImpl.self, initializer: TrainingServiceProviderImpl.init)
            .implements(TrainingServiceProvider.self)

        container.autoregister(TrainingRouter.self, initializer: TrainingRouter.init)
            .implements(TrainingPublicRouter.self, TrainingInternalRouter.self)
            .inObjectScope(.container)

        container.autoregister(TrainingTableAdapter.self, initializer: TrainingTableAdapter.init)

        container.register(TrainingViewController.self) { resolver in
            let viewController = TrainingViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(TrainingPresenter.self)!)
            return viewController
        }

        container.autoregister(TrainingPresenter.self, initializer: TrainingPresenter.init)

        container.register(TrainingViewFactory.self) { _ in
            return self
        }
    }
}

extension TrainingModule: TrainingViewFactory {
    func createViewController() -> TrainingViewController {
        return resolver.resolve(TrainingViewController.self)!
    }
}
