//
//  HomeRouter.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import UIKit

protocol HomePublicRouter: AnyObject {
    func runScreenFactory()
}

protocol HomeInternalRouter: AnyObject {
    func runChartScreen()
    func presentAlert(_ props: CustomActionSheet.Props, sourceView: UIView, place: CustomActionSheetController.Place)
}

final class HomeRouter {
    private let factory: HomeViewFactory
    private let appRouter: AppRouter
    private let chartRouter: ChartPublicRouter

    init(factory: HomeViewFactory,
         appRouter: AppRouter,
         chartRouter: ChartPublicRouter) {
        self.factory = factory
        self.appRouter = appRouter
        self.chartRouter = chartRouter
    }
}

extension HomeRouter: HomePublicRouter {
    func runScreenFactory() {
        let controller = factory.createViewController()
        appRouter.setRootModule(controller, animated: true)
    }
}

extension HomeRouter: HomeInternalRouter {
    func runChartScreen() {
        chartRouter.runScreenFactory()
    }

    func presentAlert(_ props: CustomActionSheet.Props, sourceView: UIView, place: CustomActionSheetController.Place) {
        let alert = CustomActionSheetController()
        alert.createView(props: props, sourceView: sourceView, place: place)
        appRouter.present(alert, animated: false)
    }
}
