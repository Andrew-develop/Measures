//
//  ChartPresenter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import RxSwift
import RxCocoa

final class ChartPresenter: PropsProducer {
    typealias Props = ChartViewController.Props

    private let service: ChartServiceProvider
    private let router: ChartInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: ChartServiceProvider, router: ChartInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension ChartPresenter {
    func setup() {}
}
