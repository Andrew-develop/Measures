//
//  ActivityLevelPresenter.swift
//  Shapely
//
//  Created by Andrew on 19.02.2023.
//

import RxSwift
import RxCocoa

final class ActivityLevelPresenter: PropsProducer {
    typealias Props = ActivityLevelViewController.Props

    private let service: ActivityLevelServiceProvider
    private let router: ActivityLevelInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: ActivityLevelServiceProvider, router: ActivityLevelInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension ActivityLevelPresenter {
    func setup() {
        propsRelay.mutate {
            $0.items = mapActivityModels()
        }
    }

    func mapActivityModels() -> [ActivityLevelInfoCellViewModel] {
        ActivityLevel.allCases.map { item in
            ActivityLevelInfoCellViewModel(
                props: ActivityLevelInfoCell.Props(
                    title: item.title,
                    text: item.description,
                    onTap: Command { [weak self] in
                        self?.service.levelSelected(with: item)
                        self?.router.dismiss()
                    }
                )
            )
        }
    }
}
