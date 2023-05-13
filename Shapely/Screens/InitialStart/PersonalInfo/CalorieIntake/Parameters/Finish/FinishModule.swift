//
//  FinishModule.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import Swinject
import SwinjectAutoregistration

protocol FinishViewFactory {
    func createViewController() -> FinishViewController
}

final class FinishModule: AppModule, Assembly {
    private var resolver: Resolver!

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(FinishRouter.self, initializer: FinishRouter.init)
            .implements(FinishPublicRouter.self, FinishInternalRouter.self)
            .inObjectScope(.container)
            .initCompleted { resolver, router in
                router.parametersRouter = resolver.resolve()
            }

        container.autoregister(FinishTableAdapter.self, initializer: FinishTableAdapter.init)

        container.register(FinishViewController.self) { resolver in
            let viewController = FinishViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(FinishPresenter.self)!)
            return viewController
        }

        container.autoregister(FinishPresenter.self, initializer: FinishPresenter.init)

        container.register(FinishViewFactory.self) { _ in
            return self
        }
    }
}

extension FinishModule: FinishViewFactory {
    func createViewController() -> FinishViewController {
        return resolver.resolve(FinishViewController.self)!
    }
}
