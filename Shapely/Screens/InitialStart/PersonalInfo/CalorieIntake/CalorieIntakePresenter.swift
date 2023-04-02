//
//  CalorieIntakePresenter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import RxSwift
import RxCocoa

final class CalorieIntakePresenter: PropsProducer {
    typealias Props = CalorieIntakeViewController.Props

    private let service: CalorieIntakeServiceProvider
    private let router: CalorieIntakeInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    private var pack: [InitialStartSection.CalorieIntake: [AnyHashable]] = [:] {
        didSet {
            propsRelay.mutate {
                $0.pack = pack
            }
        }
    }

    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)

    private let heightTape = InitialStartMapper.mapTape(range: CalorieIntakePresenter.heightRange)
    private let weightTape = InitialStartMapper.mapTape(range: CalorieIntakePresenter.weightRange)

    init(service: CalorieIntakeServiceProvider, router: CalorieIntakeInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }

    private lazy var heightChanged = CommandWith<Double> { [weak self] value in
        UserDefaultsHelper.height = value
        self?.pack[.heightTape] = self?.mapTapeViewModel(.heightTape)
    }

    private lazy var weightChanged = CommandWith<Double> { [weak self] value in
        UserDefaultsHelper.weight = value
        self?.pack[.weightTape] = self?.mapTapeViewModel(.weightTape)
    }
}

private extension CalorieIntakePresenter {
    func setup() {
        service.rx_activityLevel
            .bind { [weak self] level in
                UserDefaultsHelper.setActivityLevel(level)
                self?.pack[.activityData] = self?.mapActivityViewModel()
            }
            .disposed(by: disposeBag)

        propsRelay.mutate {
            $0.title = R.string.localizable.calorieIntakeTitle()
            $0.confirmProps = ConfirmView.Props(
                state: .full,
                title: R.string.localizable.buttonContinue(),
                onContinue: Command { [weak self] in
                    self?.router.runParametersScreen()
                },
                onBack: Command { [weak self] in
                    self?.router.runPersonalInfoScreen()
                }
            )
        }

        pack = [
            .heightTitle: [InitialStartTitleCellViewModel(
                props: .init(title: R.string.localizable.calorieIntakeHeight())
            )],
            .heightTape: mapTapeViewModel(.heightTape),
            .weightTitle: [InitialStartTitleCellViewModel(
                props: .init(title: R.string.localizable.calorieIntakeWeight())
            )],
            .weightTape: mapTapeViewModel(.weightTape),
            .activityTitle: [InitialStartTitleCellViewModel(
                props: .init(title: R.string.localizable.calorieIntakeActivityLevel())
            )],
            .activityData: mapActivityViewModel()
        ]
    }

    func mapTapeViewModel(_ type: InitialStartSection.CalorieIntake) -> [InitialStartTapeCellViewModel] {
        [InitialStartTapeCellViewModel(
            props: .init(
                startValue: type == .weightTape ? UserDefaultsHelper.weight : UserDefaultsHelper.height,
                measureType: type == .weightTape ? .kg : .sm,
                range: type == .weightTape ? CalorieIntakePresenter.weightRange : CalorieIntakePresenter.heightRange,
                items: type == .weightTape ? weightTape : heightTape,
                onChanged: type == .weightTape ? weightChanged : heightChanged,
                onStartScroll: Command { [weak self] in
                    self?.impactFeedbackGenerator.impactOccurred(intensity: 0.5)
                }
            )
        )]
    }

    func mapActivityViewModel() -> [InitialStartDataCellViewModel] {
        [InitialStartDataCellViewModel(
            props: .init(
                title: UserDefaultsHelper.activityLevel.title,
                isChevronHidden: false,
                isSelected: false,
                onTap: CommandWith<Bool> { [weak self] _ in
                    self?.router.runActivityLevelScreen()
                }
            )
        )]
    }
}

private extension CalorieIntakePresenter {
    static let heightRange = Range(50...250)
    static let weightRange = Range(30...300)
}
