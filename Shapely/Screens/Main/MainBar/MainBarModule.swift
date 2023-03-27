//
//  MainBarModule.swift
//  Vladlink
//
//  Created by Pavel on 13/03/2021.
//  Copyright © 2021 Vladlink. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

protocol MainBarViewFactory: AnyObject {
    func createViewController() -> MainBarViewController
    func createViewControllerItem(_ tab: MainTabBarItem) -> UINavigationController
}

final class MainBarModule: AppModule, Assembly {
    // MARK: - Properties

    private var resolver: Resolver!

    var submodules: [AppModule] = [
        HomeModule(),
        FoodModule(),
        MeasurementModule(),
        TrainingModule(),
        PhotoCollageModule()
    ]

    func createAssembly() -> Assembly? {
        return self
    }

    func loaded(resolver: Resolver) {
        self.resolver = resolver
    }

    func assemble(container: Container) {
        container.autoregister(MainBarRouter.self, initializer: MainBarRouter.init)
            .implements(MainBarPublicRouter.self, MainBarInternalRouter.self)
            .inObjectScope(.container)

        container.register(MainBarViewController.self) { resolver in
            let viewController = MainBarViewController(factory: resolver.resolve())
            return viewController
        }

        container.register(MainBarViewFactory.self) { _ in
            self
        }
    }
}

// MARK: - MainBarViewFactory

extension MainBarModule: MainBarViewFactory {
    func createViewController() -> MainBarViewController {
        return resolver.resolve(MainBarViewController.self)!
    }

    func createViewControllerItem(_ tab: MainTabBarItem) -> UINavigationController {
        let rootViewController: UIViewController
        switch tab {
        case .home:
            rootViewController = resolver.resolve(HomeViewFactory.self)!.createViewController()
        case .food:
            rootViewController = resolver.resolve(FoodViewFactory.self)!.createViewController()
        case .measurement:
            rootViewController = resolver.resolve(MeasurementViewFactory.self)!.createViewController()
        case .training:
            rootViewController = resolver.resolve(TrainingViewFactory.self)!.createViewController()
        case .photos:
            rootViewController = resolver.resolve(PhotoCollageViewFactory.self)!.createViewController()
        }
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem = tab.createItem()
        return navigationController
    }
}
