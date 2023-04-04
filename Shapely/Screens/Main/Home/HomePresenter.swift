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

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    private var widgets: [WidgetType: [AnyHashable]] = [:] {
        didSet {
            propsRelay.mutate {
                $0.widgets = widgets
            }
        }
    }

    private var isControl: Bool = false {
        didSet {
            WidgetType.allCases.forEach {
                configure($0)
            }
        }
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
            $0.title = R.string.localizable.homeTitle()
            $0.onTap = Command { [weak self] in
                guard let self else { return }
                self.isControl = !self.isControl
            }
        }

        service.rx_savedImage
            .bind { [weak self] in
                self?.configurePhotos()
            }
            .disposed(by: disposeBag)

        WidgetType.allCases.forEach {
            configure($0)
        }
    }

    func configure(_ type: WidgetType) {
        switch type {
        case .calorie:
            configureCalorie()
        case .measurements:
            configureParameters()
        case .photo:
            configurePhotos()
        case .addWidget:
            configureAddWidget()
        }
    }

    func configureCalorie() {
        widgets[.calorie] = [
            CaloriesCellViewModel(props: .init(
                state: isControl ? .control : .base,
                calories: (700, Double(UserDefaultsHelper.calorieIntake)),
                nutritions: (100, 50, 20),
                nutritionInfo: Nutritions.allCases.map { element in
                    NutritionView.Props(title: element.title, color: element.indicatorColor)
                },
                onDelete: .empty
            ))
        ]
    }

    func configureParameters() {
        Observable.combineLatest(service.fetch(Measurement.self),
                                 service.fetch(Parameter.self))
            .bind { [weak self] measurements, parameters in
                guard let self, !parameters.isEmpty else { return }

                self.widgets[.measurements] = [
                    StatisticsCellViewModel(
                        props: .init(
                            id: UUID(),
                            items: TreckingParameter.allCases.compactMap { parameter in
                                guard parameters.contains(where: { expectedParam in
                                    expectedParam.name == parameter.title
                                }) else { return nil }

                                let measurementFirst = measurements.first {
                                    $0.measureParameter?.name == parameter.title
                                }

                                let measurementLast = measurements.last {
                                    $0.measureParameter?.name == parameter.title
                                }

                                let firstValue = measurementFirst?.value ?? 0
                                let lastValue = measurementLast?.value ?? 0

                                return StatisticsPointCellViewModel(
                                    props: .init(
                                        title: parameter.title,
                                        value: firstValue != 0 ? "\(firstValue) см" : "-",
                                        diffrence: (firstValue != 0 && lastValue != 0) ? firstValue - lastValue : 0,
                                        interval: "за месяц",
                                        measure: .sm,
                                        onTap: .empty
                                    )
                                )
                            }
                        )
                    )
                ]
            }
            .disposed(by: disposeBag)
    }

    func configurePhotos() {
        service.fetch(Photo.self)
            .bind { [weak self] photos in
                guard let first = photos.first,
                      let last = photos.last else { return }
                self?.widgets[.photo] = [
                    PhotoProgressCellViewModel(
                        props: .init(
                            firstImage: UIImage(data: first.value ?? Data()),
                            lastImage: UIImage(data: last.value ?? Data()),
                            onTap: .empty
                        )
                    )
                ]
            }
            .disposed(by: disposeBag)
    }

    func configureAddWidget() {
        widgets[.addWidget] = [
            AddWidgetCellViewModel(props: .init(title: R.string.localizable.homeAddWidget(), onTap: .empty))
        ]
    }
}
