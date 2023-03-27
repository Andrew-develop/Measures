//
//  FoodPresenter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import RxSwift
import RxCocoa

final class FoodPresenter: PropsProducer {
    typealias Props = FoodViewController.Props

    private let service: FoodServiceProvider
    private let router: FoodInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: FoodServiceProvider, router: FoodInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension FoodPresenter {
    func setup() {}
}
