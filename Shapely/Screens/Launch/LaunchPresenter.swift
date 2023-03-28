//
//  LaunchPresenter.swift
//  Shapely
//
//  Created by Andrew on 12.02.2023.
//

import RxSwift
import RxCocoa

final class LaunchPresenter: PropsProducer {
    typealias Props = LaunchViewController.Props

    private let service: LaunchServiceProvider
    private let router: LaunchInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: LaunchServiceProvider, router: LaunchInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension LaunchPresenter {
    func setup() {
        service.fetch(User.self)
            .bind { [weak self] data in
                guard !data.isEmpty else {
                    self?.router.runInitialStartScreen()
                    return
                }
                self?.router.runMainScreen()
            }
            .disposed(by: disposeBag)
    }
}
