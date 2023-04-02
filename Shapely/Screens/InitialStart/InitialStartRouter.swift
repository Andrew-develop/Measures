//
//  InitialStartRouter.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import UIKit

protocol InitialStartPublicRouter: AnyObject {
    func runScreenFactory()
}

protocol InitialStartInternalRouter: AnyObject {
    func runPersonalInfoScreen()
}

final class InitialStartRouter {
    private let factory: InitialStartViewFactory
    private let personalInfoRouter: PersonalInfoPublicRouter
    private let appRouter: AppRouter

    init(factory: InitialStartViewFactory,
         personalInfoRouter: PersonalInfoPublicRouter,
         appRouter: AppRouter) {
        self.factory = factory
        self.personalInfoRouter = personalInfoRouter
        self.appRouter = appRouter
    }
}

extension InitialStartRouter: InitialStartPublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.setRootModule(controller, animated: false)
    }
}

extension InitialStartRouter: InitialStartInternalRouter {
    func runPersonalInfoScreen() {
        personalInfoRouter.runScreenFactory()
    }
}
