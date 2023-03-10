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
        calorieIntake: 2200
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

    private let heightTape = InitialStartMapper.mapTape(range: Range(50...250))
    private let weightTape = InitialStartMapper.mapTape(range: Range(30...300))

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

    // MARK: - Segue

    private lazy var personalInfoSegue = Command { [weak self] in
        self?.mapPersonalInfoPack()
    }

    private lazy var calorieIntakeSegue = Command { [weak self] in
        self?.mapCalorieIntakePack()
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
                    header: MainHeaderCellViewModel(
                        props: .init(title: R.string.localizable.initialStartTitle())
                    ),
                    viewModels: [
                        .text(InitialStartTextCellViewModel(
                            props: .init(title: R.string.localizable.initialStartInfo()))
                        ),
                        .picture(InitialStartPictureCellViewModel(
                            props: .init(picture: R.image.initialStart()))
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

    func mapPersonalInfoPack(birthdaySelected: Bool = false) {
        propsRelay.mutate {
            $0.pack = (
                .personalInfo,
                InitialStartPack(
                    header: MainHeaderCellViewModel(
                        props: .init(title: R.string.localizable.personalInfoTitle())
                    ),
                    viewModels: [
                        .segment(InitialStartSegmentCellViewModel(
                            props: .init(
                                selectedSegmentIndex: userData.gender.rawValue,
                                onSegmentChanged: CommandWith<Int> { [weak self] value in
                                    if let gender = Gender(rawValue: value) {
                                        self?.userData.gender = gender
                                    }
                                }
                            )
                        )),
                        .title(InitialStartTitleCellViewModel(
                            props: .init(title: R.string.localizable.personalInfoBirthday()))
                        ),
                        .data(InitialStartDataCellViewModel(
                            props: .init(
                                title: makeStringDate(from: userData.birthday),
                                isChevronHidden: true,
                                isSelected: birthdaySelected,
                                onTap: Command { [weak self] in
                                    self?.makeCalendarVisible(true)
                                }
                            )
                        )),
                        .title(InitialStartTitleCellViewModel(
                            props: .init(title: R.string.localizable.personalInfoTarget()))
                        ),
                        .data(InitialStartDataCellViewModel(
                            props: .init(
                                title: userData.target.description,
                                isChevronHidden: false,
                                isSelected: false,
                                onTap: Command { [weak self] in
                                    guard let self else { return }
                                    self.router.runActionSheet(with: self.targetActionSheet)
                                }
                            )
                        ))
                    ]
                )
            )
            $0.confirmProps = ConfirmView.Props(
                state: .regular,
                title: R.string.localizable.buttonContinue(),
                onContinue: calorieIntakeSegue,
                onBack: .empty
            )
            $0.calendarProps = CalendarView.Props(
                selectedDate: Calendar.current.dateComponents(in: .current, from: userData.birthday),
                onSelect: CommandWith<DateComponents?> { [weak self] value in
                    self?.setDate(value)
                },
                onDone: Command { [weak self] in
                    self?.makeCalendarVisible(false)
                }
            )
        }
    }

    func mapCalorieIntakePack() {
        propsRelay.mutate {
            $0.pack = (
                .calorieIntake,
                InitialStartPack(
                    header: MainHeaderCellViewModel(
                        props: .init(title: R.string.localizable.calorieIntakeTitle())
                    ),
                    viewModels: [
                        .title(InitialStartTitleCellViewModel(
                            props: .init(title: R.string.localizable.calorieIntakeHeight()))
                        ),
                        .tape(InitialStartTapeCellViewModel(
                            props: .init(
                                startValue: userData.height,
                                measureType: .sm,
                                range: Range(50...250),
                                items: heightTape,
                                onChanged: CommandWith<Double> { [weak self] value in
                                    self?.setHeight(value)
                                }
                            )
                        )),
                        .title(InitialStartTitleCellViewModel(
                            props: .init(title: R.string.localizable.calorieIntakeWeight()))
                        ),
                        .tape(InitialStartTapeCellViewModel(
                            props: .init(
                                startValue: userData.weight,
                                measureType: .kg,
                                range: Range(30...300),
                                items: weightTape,
                                onChanged: CommandWith<Double> { [weak self] value in
                                    self?.setWeight(value)
                                }
                            )
                        )),
                        .title(InitialStartTitleCellViewModel(
                            props: .init(title: R.string.localizable.calorieIntakeActivityLevel()))
                        ),
                        .data(InitialStartDataCellViewModel(
                            props: .init(
                                title: userData.activityLevel.title,
                                isChevronHidden: false,
                                isSelected: false,
                                onTap: Command { [weak self] in
                                    self?.router.runActivityLevelScreen()
                                }
                            )
                        ))
                    ]
                )
            )
            $0.isNeedCalendar = false
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
                    header: MainHeaderCellViewModel(
                        props: .init(title: R.string.localizable.parametersTitle())
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
                onBack: calorieIntakeSegue
            )
        }
    }

    func mapFinalPack(with calculation: Bool = true) {
        if calculation {
            getCalorieIntake()
        }
        propsRelay.mutate {
            $0.pack = (
                .finish,
                InitialStartPack(
                    header: MainHeaderCellViewModel(
                        props: .init(title: R.string.localizable.finishTitle())
                    ),
                    viewModels: [
                        .text(InitialStartTextCellViewModel(
                            props: .init(title: R.string.localizable.finishFirstInfo()))
                        ),
                        .edit(InitialStartEditCellViewModel(
                            props: .init(
                                text: String(userData.calorieIntake) + " " + Measure.kcal.rawValue,
                                onTap: Command { [weak self] in
                                    self?.showEditDialog()
                                }
                            ))
                        ),
                        .text(InitialStartTextCellViewModel(
                            props: .init(title: R.string.localizable.finishSecondInfo()))
                        )
                    ]
                )
            )
            $0.confirmProps = ConfirmView.Props(
                state: .full,
                title: R.string.localizable.buttonReady(),
                onContinue: Command { [weak self] in
                    self?.finishSetup()
                },
                onBack: parametersSegue
            )
        }
    }

    // MARK: - Helpers

    func makeCalendarVisible(_ value: Bool) {
        propsRelay.mutate {
            $0.isNeedCalendar = value
        }
        mapPersonalInfoPack(birthdaySelected: value)
    }

    func setTarget(_ target: UserTarget) {
        userData.target = target
        mapPersonalInfoPack()
    }

    func setDate(_ value: DateComponents?) {
        guard let value = value,
              let date = Calendar.current.date(from: value) else { return }
        userData.birthday = date
        mapPersonalInfoPack(birthdaySelected: true)
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
        mapCalorieIntakePack()
    }

    func setHeight(_ value: Double) {
        userData.height = value
        mapCalorieIntakePack()
    }

    func setWeight(_ value: Double) {
        userData.weight = value
        mapCalorieIntakePack()
    }

    func makeStringDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.dateFullMonth.rawValue
        return formatter.string(from: date)
    }

    func showEditDialog() {
        let editDialog = with(DialogController()) {
            $0.props = $0.props.mutate {
                $0.title = R.string.localizable.finishAlertTitle()
                $0.value = userData.calorieIntake
                $0.measure = .kcal
                $0.onSave = CommandWith { [weak self] value in
                    guard let value = value else { return }
                    self?.userData.calorieIntake = value
                    self?.mapFinalPack(with: false)
                }
            }
        }
        router.showDialog(editDialog)
    }

    func getCalorieIntake() {
        service.calculateCalorieIntake(with: userData)
            .bind { [weak self] value in
                self?.userData.calorieIntake = value
            }
            .disposed(by: disposeBag)
    }

    func finishSetup() {
        service.addUser { [weak self] newUser in
            guard let self else { return }
            newUser.height = self.userData.height
            newUser.weight = self.userData.weight
            newUser.gender = self.userData.gender.description
            newUser.target = self.userData.target.description
            newUser.activityLevel = self.userData.activityLevel.title
            newUser.birthday = self.userData.birthday
            newUser.calorieIntake = Int64(self.userData.calorieIntake)
            newUser.userParameter = []
        }.bind { [weak self] in
            self?.router.runHomeScreen()
        }
        .disposed(by: disposeBag)
    }
}
