//
//  TrainingRouter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

protocol TrainingPublicRouter: AnyObject {}

protocol TrainingInternalRouter: AnyObject {}

final class TrainingRouter {
    private let factory: TrainingViewFactory

    init(factory: TrainingViewFactory) {
        self.factory = factory
    }
}

extension TrainingRouter: TrainingPublicRouter {}

extension TrainingRouter: TrainingInternalRouter {}
