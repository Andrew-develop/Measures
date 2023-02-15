//
//  MainCoordinator.swift
//  Shapely
//
//  Created by Andrew on 11.02.2023.
//

import Swinject
import UIKit

final class MainCoordinator {
    private let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
    }

    func mainViewController() -> RootNavigationController {
        let rootController = resolver.resolve(RootNavigationController.self)!
        let controller = resolver.resolve(LaunchViewFactory.self)!.createViewController()
        rootController.setViewControllers([controller], animated: false)
        return rootController
    }
}
