//
//  MeasurementModule.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import Swinject
import SwinjectAutoregistration

protocol MeasurementViewFactory {
    func createViewController() -> MeasurementViewController
}

final class MeasurementModule: AppModule, Assembly {
    private var resolver: Resolver!

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(MeasurementServiceProviderImpl.self, initializer: MeasurementServiceProviderImpl.init)
            .implements(MeasurementServiceProvider.self)

        container.autoregister(MeasurementRouter.self, initializer: MeasurementRouter.init)
            .implements(MeasurementPublicRouter.self, MeasurementInternalRouter.self)
            .inObjectScope(.container)

        container.autoregister(MeasurementTableAdapter.self, initializer: MeasurementTableAdapter.init)

        container.register(MeasurementViewController.self) { resolver in
            let viewController = MeasurementViewController(tableAdapter: resolver.resolve())
            viewController.bind(to: resolver.resolve(MeasurementPresenter.self)!)
            return viewController
        }

        container.autoregister(MeasurementPresenter.self, initializer: MeasurementPresenter.init)

        container.register(MeasurementViewFactory.self) { _ in
            return self
        }
    }
}

extension MeasurementModule: MeasurementViewFactory {
    func createViewController() -> MeasurementViewController {
        return resolver.resolve(MeasurementViewController.self)!
    }
}
