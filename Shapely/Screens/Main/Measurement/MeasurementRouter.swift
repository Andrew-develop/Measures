//
//  MeasurementRouter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

protocol MeasurementPublicRouter: AnyObject {}

protocol MeasurementInternalRouter: AnyObject {
    func showDialog(_ dialog: DialogController)
}

final class MeasurementRouter {
    private let factory: MeasurementViewFactory
    private let appRouter: AppRouter

    init(factory: MeasurementViewFactory,
         appRouter: AppRouter) {
        self.factory = factory
        self.appRouter = appRouter
    }
}

extension MeasurementRouter: MeasurementPublicRouter {}

extension MeasurementRouter: MeasurementInternalRouter {
    func showDialog(_ dialog: DialogController) {
        appRouter.present(dialog, animated: true)
    }
}
