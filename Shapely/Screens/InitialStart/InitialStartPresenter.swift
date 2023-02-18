//
//  InitialStartPresenter.swift
//  Shapely
//
//  Created by Andrew on 15.02.2023.
//

import RxSwift
import RxCocoa

final class InitialStartPresenter: PropsProducer {
    typealias Props = InitialStartViewController.Props

    private let service: InitialStartServiceProvider
    private let router: InitialStartInternalRouter
    private let disposeBag = DisposeBag()

    private var userData = UserData(
        gender: .male,
        birthday: Date(),
        target: .loseWeight,
        height: 170.0,
        weight: 60.0,
        activityLevel: .good,
        treckingParameters: [.chest, .biceps, .waist, .pelvis, .hip],
        caloryIntake: 2200
    )

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: InitialStartServiceProvider, router: InitialStartInternalRouter) {
        self.service = service
        self.router = router

        mapStartPack()
    }

    private lazy var onSegmentChanged = CommandWith<Int> { [weak self] value in
        if let gender = Gender(rawValue: value) {
            self?.userData.gender = gender
        }
    }

    private lazy var onTapBirthday = Command { [weak self] in
        self?.makeCalendarVisible(true)
    }

    private lazy var onCalendarDone = Command { [weak self] in
        self?.makeCalendarVisible(false)
    }

    // MARK: - Segues

    private lazy var personalInfoSegue = Command { [weak self] in
        self?.mapPersonalInfoPack()
    }

    private lazy var weightSegue = Command { [weak self] in
        self?.mapWeightPack()
    }
}

private extension InitialStartPresenter {
    func mapStartPack() {
        propsRelay.mutate {
            $0.pack = (
                .start,
                InitialStartPack(
                    header: InitialStartMapper.mapHeader(
                        with: R.string.localizable.initialStartTitle()
                    ),
                    viewModels: [
                        .text(
                            InitialStartMapper.mapText(
                                with: R.string.localizable.initialStartInfo()
                            )
                        ),
                        .picture(
                            InitialStartMapper.mapPicture(
                                with: R.image.initialStart()
                            )
                        )
                    ]
                )
            )
            $0.confirmProps = ConfirmView.Props(
                state: .regular,
                title: R.string.localizable.buttonStart(),
                onContinue: personalInfoSegue,
                onBack: .empty
            )
        }
    }

    func mapPersonalInfoPack() {
        propsRelay.mutate {
            $0.pack = (
                .personalInfo,
                InitialStartPack(
                    header: InitialStartMapper.mapHeader(
                        with: R.string.localizable.personalInfoTitle()
                    ),
                    viewModels: [
                        .segment(
                            InitialStartMapper.mapSegment(
                                with: userData.gender,
                                onSegmentChanged: onSegmentChanged
                            )
                        ),
                        .title(
                            InitialStartMapper.mapTitle(
                                with: R.string.localizable.personalInfoBirthday()
                            )
                        ),
                        .data(
                            InitialStartMapper.mapData(
                                title: userData.birthday.description,
                                isChevronHidden: true,
                                onTap: onTapBirthday
                            )
                        ),
                        .title(
                            InitialStartMapper.mapTitle(
                                with: R.string.localizable.personalInfoTarget()
                            )
                        ),
                        .data(
                            InitialStartMapper.mapData(
                                title: userData.target.description,
                                isChevronHidden: false,
                                onTap: .empty
                            )
                        )
                    ]
                )
            )
            $0.confirmProps = ConfirmView.Props(
                state: .regular,
                title: R.string.localizable.buttonContinue(),
                onContinue: weightSegue,
                onBack: .empty
            )
            $0.calendarProps = CalendarView.Props(
                selectedDate: DateComponents(year: 2023, month: 2, day: 14),
                onSelect: .empty,
                onDone: onCalendarDone
            )
        }
    }

    func mapWeightPack() {}

    func mapParametersPack() {}

    func mapFinalPack() {}

    // MARK: - Helpers

    func makeCalendarVisible(_ value: Bool) {
        propsRelay.mutate {
            $0.isNeedCalendar = value
        }
    }
}
