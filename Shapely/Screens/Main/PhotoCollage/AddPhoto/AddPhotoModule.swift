//
//  AddPhotoModule.swift
//  Shapely
//
//  Created by Andrew on 13.03.2023.
//

import Swinject
import SwinjectAutoregistration

protocol AddPhotoViewFactory {
    func createViewController() -> AddPhotoViewController
}

final class AddPhotoModule: AppModule, Assembly {
    private var resolver: Resolver!

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(AddPhotoServiceProviderImpl.self, initializer: AddPhotoServiceProviderImpl.init)
            .implements(AddPhotoServiceProvider.self)
            .inObjectScope(.container)

        container.autoregister(AddPhotoRouter.self, initializer: AddPhotoRouter.init)
            .implements(AddPhotoPublicRouter.self, AddPhotoInternalRouter.self)
            .inObjectScope(.container)

        container.register(AddPhotoViewController.self) { resolver in
            let viewController = AddPhotoViewController()
            viewController.bind(to: resolver.resolve(AddPhotoPresenter.self)!)
            return viewController
        }

        container.autoregister(AddPhotoPresenter.self, initializer: AddPhotoPresenter.init)

        container.register(AddPhotoViewFactory.self) { _ in
            return self
        }
    }
}

extension AddPhotoModule: AddPhotoViewFactory {
    func createViewController() -> AddPhotoViewController {
        return resolver.resolve(AddPhotoViewController.self)!
    }
}
