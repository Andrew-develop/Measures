//
//  ChartModule.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import Swinject
import SwinjectAutoregistration

protocol ChartViewFactory {
    func createViewController() -> ChartViewController
}

final class ChartModule: AppModule, Assembly {
    private var resolver: Resolver!

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(ChartServiceProviderImpl.self, initializer: ChartServiceProviderImpl.init)
            .implements(ChartServiceProvider.self)

        container.autoregister(ChartRouter.self, initializer: ChartRouter.init)
            .implements(ChartPublicRouter.self, ChartInternalRouter.self)
            .inObjectScope(.container)

        container.autoregister(ChartTableAdapter.self, initializer: ChartTableAdapter.init)

        container.register(ChartViewController.self) { resolver in
            let viewController = ChartViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(ChartPresenter.self)!)
            return viewController
        }

        container.autoregister(ChartPresenter.self, initializer: ChartPresenter.init)

        container.register(ChartViewFactory.self) { _ in
            return self
        }
    }
}

extension ChartModule: ChartViewFactory {
    func createViewController() -> ChartViewController {
        return resolver.resolve(ChartViewController.self)!
    }
}
