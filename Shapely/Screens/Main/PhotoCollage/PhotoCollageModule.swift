//
//  PhotoCollageModule.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import Swinject
import SwinjectAutoregistration

protocol PhotoCollageViewFactory {
    func createViewController() -> PhotoCollageViewController
}

final class PhotoCollageModule: AppModule, Assembly {
    private var resolver: Resolver!

    var submodules: [AppModule] = [
        AddPhotoModule()
    ]

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(PhotoCollageServiceProviderImpl.self, initializer: PhotoCollageServiceProviderImpl.init)
            .implements(PhotoCollageServiceProvider.self)

        container.autoregister(PhotoCollageRouter.self, initializer: PhotoCollageRouter.init)
            .implements(PhotoCollagePublicRouter.self, PhotoCollageInternalRouter.self)
            .inObjectScope(.container)

        container.autoregister(PhotoCollageTableAdapter.self, initializer: PhotoCollageTableAdapter.init)
        container.autoregister(PhotoCollageDaysTableAdapter.self, initializer: PhotoCollageDaysTableAdapter.init)

        container.register(PhotoCollageViewController.self) { resolver in
            let viewController = PhotoCollageViewController(tableAdapter: resolver.resolve(),
                                                            daysTableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(PhotoCollagePresenter.self)!)
            return viewController
        }

        container.autoregister(PhotoCollagePresenter.self, initializer: PhotoCollagePresenter.init)

        container.register(PhotoCollageViewFactory.self) { _ in
            return self
        }
    }
}

extension PhotoCollageModule: PhotoCollageViewFactory {
    func createViewController() -> PhotoCollageViewController {
        return resolver.resolve(PhotoCollageViewController.self)!
    }
}
