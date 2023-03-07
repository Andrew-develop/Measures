//
//  HomePresenter.swift
//  Shapely
//
//  Created by Andrew on 07.03.2023.
//

import RxSwift
import RxCocoa

final class HomePresenter: PropsProducer {
    typealias Props = HomeViewController.Props

    private let service: HomeServiceProvider
    private let router: HomeInternalRouter
    private let disposeBag = DisposeBag()

    private var userData = UserData(
        gender: .male,
        birthday: Date(),
        target: .loseWeight,
        height: 170.0,
        weight: 60.0,
        activityLevel: .good,
        treckingParameters: [.chest, .biceps, .waist, .pelvis, .hip],
        calorieIntake: 2200
    )

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: HomeServiceProvider, router: HomeInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension HomePresenter {
    func setup() {
        propsRelay.mutate {
            $0.pack = (
                .base,
                WidgetInfoPack(
                    header: MainControlHeaderCellViewModel(
                        props: .init(title: R.string.localizable.homeTitle(), onTap: .empty)
                    ),
                    viewModels: [
                        .calories(CaloriesCellViewModel(
                            props: .init(state: .base, calories: (0, userData.calorieIntake), nutritions: (0, 0, 0)))
                        ),
                        .addWidget(AddWidgetCellViewModel(props: .init(onTap: .empty)))
                    ]
                )
            )
        }
    }
}
