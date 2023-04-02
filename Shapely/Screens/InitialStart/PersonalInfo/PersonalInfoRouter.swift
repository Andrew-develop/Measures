//
//  PersonalInfoRouter.swift
//  Shapely
//
//  Created by Andrew on 31.03.2023.
//

import UIKit

protocol PersonalInfoPublicRouter: AnyObject {
    func runScreenFactory()
}

protocol PersonalInfoInternalRouter: AnyObject {
    func runActionSheet(with controller: UIAlertController)
    func runCalorieIntake()
}

final class PersonalInfoRouter {
    private let factory: PersonalInfoViewFactory
    private let appRouter: AppRouter
    private let calorieIntakeRouter: CalorieIntakePublicRouter

    init(factory: PersonalInfoViewFactory,
         appRouter: AppRouter,
         calorieIntakeRouter: CalorieIntakePublicRouter) {
        self.factory = factory
        self.appRouter = appRouter
        self.calorieIntakeRouter = calorieIntakeRouter
    }
}

extension PersonalInfoRouter: PersonalInfoPublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.setRootModule(controller, animated: false)
    }
}

extension PersonalInfoRouter: PersonalInfoInternalRouter {
    func runActionSheet(with controller: UIAlertController) {
        appRouter.present(controller, animated: true)
    }

    func runCalorieIntake() {
        calorieIntakeRouter.runScreenFactory()
    }
}
