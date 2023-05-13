//
//  PersonalInfoPresenter.swift
//  Shapely
//
//  Created by Andrew on 31.03.2023.
//

import RxSwift
import RxCocoa

final class PersonalInfoPresenter: PropsProducer {
    typealias Props = PersonalInfoViewController.Props

    private let service: InitialStartServiceProvider
    private let router: PersonalInfoInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    private var pack: [InitialStartSection.PersonalInfo: [AnyHashable]] = [:] {
        didSet {
            propsRelay.mutate {
                $0.pack = pack
            }
        }
    }

    init(service: InitialStartServiceProvider, router: PersonalInfoInternalRouter) {
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
                guard let self else { return }
                UserDefaultsHelper.setTarget(target)
                self.pack[.targetData] = self.mapDataViewModel(isSelected: false, .targetData)
            }
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: R.string.localizable.buttonCancel(), style: .cancel)
        alert.addAction(cancel)
    }

    private lazy var birthdayAction = CommandWith<Bool> { [weak self] value in
        guard let self else { return }
        self.makeCalendarVisible(!value)
        self.pack[.birthData] = self.mapDataViewModel(isSelected: !value, .birthData)
    }

    private lazy var targetAction = CommandWith<Bool> { [weak self] _ in
        guard let self else { return }
        self.pack[.targetData] = self.mapDataViewModel(isSelected: true, .targetData)
        self.router.runActionSheet(with: self.targetActionSheet)
    }
}

private extension PersonalInfoPresenter {
    func setup() {
        propsRelay.mutate {
            $0.title = R.string.localizable.personalInfoTitle()
            $0.confirmProps = ConfirmView.Props(
                state: .regular,
                title: R.string.localizable.buttonContinue(),
                onContinue: Command { [weak self] in
                    self?.router.runCalorieIntake()
                },
                onBack: .empty
            )
            $0.calendarProps = CalendarView.Props(
                selectedDate: Calendar.current.dateComponents(in: .current, from: UserDefaultsHelper.birthday),
                onSelect: CommandWith<DateComponents?> { [weak self] value in
                    guard let self,
                          let value = value,
                          let date = Calendar.current.date(from: value) else { return }
                    UserDefaultsHelper.birthday = date
                    self.pack[.birthData] = self.mapDataViewModel(isSelected: true, .birthData)
                },
                onDone: Command { [weak self] in
                    guard let self else { return }
                    self.makeCalendarVisible(false)
                    self.pack[.birthData] = self.mapDataViewModel(isSelected: false, .birthData)
                }
            )
        }

        pack = [
            .segment: [InitialStartSegmentCellViewModel(
                props: .init(
                    selectedSegmentIndex: UserDefaultsHelper.gender.rawValue,
                    onSegmentChanged: CommandWith<Int> { value in
                        if let gender = Gender(rawValue: value) {
                            UserDefaultsHelper.setGender(gender)
                        }
                    }
                )
            )],
            .birthTitle: [InitialStartTitleCellViewModel(
                props: .init(title: R.string.localizable.personalInfoBirthday())
            )],
            .birthData: mapDataViewModel(isSelected: false, .birthData),
            .targetTitle: [InitialStartTitleCellViewModel(
                props: .init(title: R.string.localizable.personalInfoTarget())
            )],
            .targetData: mapDataViewModel(isSelected: false, .targetData)
        ]
    }

    func mapDataViewModel(isSelected: Bool, _ type: InitialStartSection.PersonalInfo) -> [InitialStartDataCellViewModel] {
        [InitialStartDataCellViewModel(
            props: .init(
                title: type == .birthData ?
                makeStringDate(from: UserDefaultsHelper.birthday) :
                    UserDefaultsHelper.target.description,
                isChevronHidden: type == .birthData ? true : false,
                isSelected: isSelected,
                onTap: type == .birthData ? birthdayAction : targetAction
            )
        )]
    }

    func makeCalendarVisible(_ value: Bool) {
        propsRelay.mutate {
            $0.isNeedCalendar = value
        }
    }

    func makeStringDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormat.dateFullMonth.rawValue
        return formatter.string(from: date)
    }
}
