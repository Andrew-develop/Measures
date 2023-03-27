//
//  TrainingPresenter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import RxSwift
import RxCocoa

final class TrainingPresenter: PropsProducer {
    typealias Props = TrainingViewController.Props

    private let service: TrainingServiceProvider
    private let router: TrainingInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: TrainingServiceProvider, router: TrainingInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension TrainingPresenter {
    func setup() {}
}
