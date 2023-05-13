//
//  AddPhotoModule.swift
//  Shapely
//
//  Created by Andrew on 13.03.2023.
//

import Swinject
import SwinjectAutoregistration

protocol AddPhotoViewFactory {
    func createViewController(_ image: UIImage) -> AddPhotoViewController
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

        container.register(AddPhotoViewController.self) { (resolver, image: UIImage) in
            let viewController = AddPhotoViewController()
            viewController.bind(to: resolver.resolve(AddPhotoPresenter.self, argument: image)!)
            return viewController
        }

        container.register(AddPhotoPresenter.self) { (resolver, image: UIImage) in
            AddPhotoPresenter(
                service: resolver.resolve(),
                router: resolver.resolve(),
                image: image,
                angel: .front
            )
        }

        container.register(AddPhotoViewFactory.self) { _ in
            return self
        }
    }
}

extension AddPhotoModule: AddPhotoViewFactory {
    func createViewController(_ image: UIImage) -> AddPhotoViewController {
        return resolver.resolve(AddPhotoViewController.self, argument: image)!
    }
}
