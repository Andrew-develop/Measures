//
//  FoodRouter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

protocol FoodPublicRouter: AnyObject {}

protocol FoodInternalRouter: AnyObject {}

final class FoodRouter {
    private let factory: FoodViewFactory

    init(factory: FoodViewFactory) {
        self.factory = factory
    }
}

extension FoodRouter: FoodPublicRouter {}

extension FoodRouter: FoodInternalRouter {}
