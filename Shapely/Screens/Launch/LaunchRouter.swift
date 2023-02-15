//
//  LaunchRouter.swift
//  Shapely
//
//  Created by Andrew on 12.02.2023.
//

protocol LaunchPublicRouter: AnyObject {}

protocol LaunchInternalRouter: AnyObject {}

final class LaunchRouter {
    private let factory: LaunchViewFactory

    init(factory: LaunchViewFactory) {
        self.factory = factory
    }
}

extension LaunchRouter: LaunchPublicRouter {}

extension LaunchRouter: LaunchInternalRouter {}
