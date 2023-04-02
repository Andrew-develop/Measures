//
//  InitialStartModule.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import Swinject
import SwinjectAutoregistration

protocol InitialStartViewFactory {
    func createViewController() -> InitialStartViewController
}

final class InitialStartModule: AppModule, Assembly {
    private var resolver: Resolver!

    var submodules: [AppModule] = [
        PersonalInfoModule()
    ]

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(InitialStartRouter.self, initializer: InitialStartRouter.init)
            .implements(InitialStartPublicRouter.self, InitialStartInternalRouter.self)
            .inObjectScope(.container)

        container.autoregister(InitialStartTableAdapter.self, initializer: InitialStartTableAdapter.init)

        container.register(InitialStartViewController.self) { resolver in
            let viewController = InitialStartViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(InitialStartPresenter.self)!)
            return viewController
        }

        container.autoregister(InitialStartPresenter.self, initializer: InitialStartPresenter.init)

        container.register(InitialStartViewFactory.self) { _ in
            return self
        }
    }
}

extension InitialStartModule: InitialStartViewFactory {
    func createViewController() -> InitialStartViewController {
        return resolver.resolve(InitialStartViewController.self)!
    }
}
