//
//  PersonalInfoModule.swift
//  Shapely
//
//  Created by Andrew on 31.03.2023.
//

import Swinject
import SwinjectAutoregistration

protocol PersonalInfoViewFactory {
    func createViewController() -> PersonalInfoViewController
}

final class PersonalInfoModule: AppModule, Assembly {
    private var resolver: Resolver!

    var submodules: [AppModule] = [
        CalorieIntakeModule()
    ]

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(PersonalInfoRouter.self, initializer: PersonalInfoRouter.init)
            .implements(PersonalInfoPublicRouter.self, PersonalInfoInternalRouter.self)
            .inObjectScope(.container)

        container.autoregister(PersonalInfoTableAdapter.self, initializer: PersonalInfoTableAdapter.init)

        container.register(PersonalInfoViewController.self) { resolver in
            let viewController = PersonalInfoViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(PersonalInfoPresenter.self)!)
            return viewController
        }

        container.autoregister(PersonalInfoPresenter.self, initializer: PersonalInfoPresenter.init)

        container.register(PersonalInfoViewFactory.self) { _ in
            return self
        }
    }
}

extension PersonalInfoModule: PersonalInfoViewFactory {
    func createViewController() -> PersonalInfoViewController {
        return resolver.resolve(PersonalInfoViewController.self)!
    }
}
