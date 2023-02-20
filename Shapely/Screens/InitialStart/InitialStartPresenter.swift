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

        setup()
    }

    private lazy var targetActionSheet = with(UIAlertController(
        title: R.string.localizable.userTargetSelect(), message: nil, preferredStyle: .actionSheet)
    ) { alert in
        alert.apply(.primary)
        UserTarget.allCases.forEach { target in
            let action = UIAlertAction(title: target.description, style: .default) { [weak self] _ in
                self?.setTarget(target)
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: R.string.localizable.buttonCancel(), style: .cancel)
        alert.addAction(cancel)
    }

    // MARK: - Commands

    private lazy var onSegmentChanged = CommandWith<Int> { [weak self] value in
        if let gender = Gender(rawValue: value) {
            self?.userData.gender = gender
        }
    }

    private lazy var onSelectDate = CommandWith<DateComponents?> { [weak self] value in
        self?.setDate(value)
    }

    private lazy var onSelectParameter = CommandWith<TreckingParameter> { [weak self] value in
        self?.setParameter(value)
    }

    private lazy var onTapBirthday = Command { [weak self] in
        self?.makeCalendarVisible(true)
    }

    private lazy var onCalendarDone = Command { [weak self] in
        self?.makeCalendarVisible(false)
    }

    private lazy var onTapTarget = Command { [weak self] in
        guard let self else { return }
        self.router.runActionSheet(with: self.targetActionSheet)
    }

    private lazy var onTapActivity = Command { [weak self] in
        self?.router.runActivityLevelScreen()
    }

    private lazy var onTapEdit = Command { [weak self] in
        guard let self else { return }
        self.router.runActionSheet(with: self.targetActionSheet)
    }

    // MARK: - Segue

    private lazy var personalInfoSegue = Command { [weak self] in
        self?.mapPersonalInfoPack()
    }

    private lazy var caloryIntakeSegue = Command { [weak self] in
        self?.mapCaloryIntakePack()
    }

    private lazy var parametersSegue = Command { [weak self] in
        self?.mapParametersPack()
    }

    private lazy var finalSegue = Command { [weak self] in
        self?.mapFinalPack()
    }
}

private extension InitialStartPresenter {
    func setup() {
        service.rx_activityLevel
            .bind { [weak self] level in
                self?.setActivityLevel(level)
            }
            .disposed(by: disposeBag)

        mapStartPack()
    }

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
                                title: makeStringDate(from: userData.birthday),
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
                                onTap: onTapTarget
                            )
                        )
                    ]
                )
            )
            $0.confirmProps = ConfirmView.Props(
                state: .regular,
                title: R.string.localizable.buttonContinue(),
                onContinue: caloryIntakeSegue,
                onBack: .empty
            )
            $0.calendarProps = CalendarView.Props(
                selectedDate: Calendar.current.dateComponents(in: .current, from: userData.birthday),
                onSelect: onSelectDate,
                onDone: onCalendarDone
            )
        }
    }

    func mapCaloryIntakePack() {
        propsRelay.mutate {
            $0.pack = (
                .caloryIntake,
                InitialStartPack(
                    header: InitialStartMapper.mapHeader(
                        with: R.string.localizable.caloryIntakeTitle()
                    ),
                    viewModels: [
                        .title(
                            InitialStartMapper.mapTitle(
                                with: R.string.localizable.caloryIntakeHeight()
                            )
                        ),
                        .tape(
                            InitialStartMapper.mapTape(
                                startValue: userData.height,
                                measureType: .sm,
                                interval: Range(50...250),
                                onChanged: .empty
                            )
                        ),
                        .title(
                            InitialStartMapper.mapTitle(
                                with: R.string.localizable.caloryIntakeWeight()
                            )
                        ),
                        .tape(
                            InitialStartMapper.mapTape(
                                startValue: userData.weight,
                                measureType: .kg,
                                interval: Range(30...300),
                                onChanged: .empty
                            )
                        ),
                        .title(
                            InitialStartMapper.mapTitle(
                                with: R.string.localizable.caloryIntakeActivityLevel()
                            )
                        ),
                        .data(
                            InitialStartMapper.mapData(
                                title: userData.activityLevel.title,
                                isChevronHidden: false,
                                onTap: onTapActivity
                            )
                        )
                    ]
                )
            )
            $0.confirmProps = ConfirmView.Props(
                state: .full,
                title: R.string.localizable.buttonContinue(),
                onContinue: parametersSegue,
                onBack: personalInfoSegue
            )
        }
    }

    func mapParametersPack() {
        propsRelay.mutate {
            $0.pack = (
                .parameters,
                InitialStartPack(
                    header: InitialStartMapper.mapHeader(
                        with: R.string.localizable.parametersTitle()
                    ),
                    viewModels:
                        TreckingParameter.allCases.sorted {
                            userData.treckingParameters.contains($0) &&
                            !userData.treckingParameters.contains($1)
                        }
                        .map { parameter in
                            .parameter(
                                InitialStartParameterCellViewModel(
                                    props: InitialStartParameterCell.Props(
                                        parameter: parameter,
                                        isSelected: userData.treckingParameters.contains(parameter),
                                        onTap: Command { [weak self] in
                                            self?.setParameter(parameter)
                                        }
                                    )
                                )
                            )
                        }
                )
            )
            $0.confirmProps = ConfirmView.Props(
                state: .full,
                title: R.string.localizable.buttonContinue(),
                onContinue: finalSegue,
                onBack: caloryIntakeSegue
            )
        }
    }

    func mapFinalPack() {
        propsRelay.mutate {
            $0.pack = (
                .finish,
                InitialStartPack(
                    header: InitialStartMapper.mapHeader(
                        with: R.string.localizable.finishTitle()
                    ),
                    viewModels: [
                        .text(
                            InitialStartMapper.mapText(
                                with: R.string.localizable.finishFirstInfo()
                            )
                        ),
                        .edit(
                            InitialStartMapper.mapEdit(
                                text: String(userData.caloryIntake) + " " + Measure.kcal.rawValue,
                                onTap: onTapEdit
                            )
                        ),
                        .text(
                            InitialStartMapper.mapText(
                                with: R.string.localizable.finishSecondInfo()
                            )
                        )
                    ]
                )
            )
            $0.confirmProps = ConfirmView.Props(
                state: .full,
                title: R.string.localizable.buttonReady(),
                onContinue: .empty,
                onBack: parametersSegue
            )
        }
    }

    // MARK: - Helpers

    func makeCalendarVisible(_ value: Bool) {
        propsRelay.mutate {
            $0.isNeedCalendar = value
        }
    }

    func setTarget(_ target: UserTarget) {
        userData.target = target
        mapPersonalInfoPack()
    }

    func setDate(_ value: DateComponents?) {
        guard let value = value,
              let date = Calendar.current.date(from: value) else { return }
        userData.birthday = date
        mapPersonalInfoPack()
    }

    func setParameter(_ parameter: TreckingParameter) {
        if userData.treckingParameters.contains(parameter) {
            userData.treckingParameters.remove(parameter)
        } else {
            userData.treckingParameters.insert(parameter)
        }
        mapParametersPack()
    }

    func setActivityLevel(_ level: ActivityLevel) {
        userData.activityLevel = level
        mapCaloryIntakePack()
    }

    func makeStringDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.dateFullMonth.rawValue
        return formatter.string(from: date)
    }

    func sortParameters(_ parameters: [InitialStartParameterCellViewModel]) -> [InitialStartParameterCellViewModel] {
        parameters.sorted { $0.props.isSelected && !$1.props.isSelected }
    }
}
