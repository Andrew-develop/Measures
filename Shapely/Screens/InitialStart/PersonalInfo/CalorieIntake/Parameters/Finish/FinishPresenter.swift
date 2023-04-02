//
//  FinishPresenter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import RxSwift
import RxCocoa

final class FinishPresenter: PropsProducer {
    typealias Props = FinishViewController.Props

    private let service: FinishServiceProvider
    private let router: FinishInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    private var pack: [InitialStartSection.Finish: [AnyHashable]] = [:] {
        didSet {
            propsRelay.mutate {
                $0.pack = pack
            }
        }
    }

    init(service: FinishServiceProvider, router: FinishInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension FinishPresenter {
    func setup() {
        UserDefaultsHelper.calorieIntake = CalorieCalculator.calculateCalorieIntake()

        propsRelay.mutate {
            $0.title = R.string.localizable.finishTitle()
            $0.confirmProps = ConfirmView.Props(
                state: .full,
                title: R.string.localizable.buttonReady(),
                onContinue: Command { [weak self] in
                    self?.finishSetup()
                },
                onBack: Command { [weak self] in
                    self?.router.runParametersScreen()
                }
            )
        }

        pack = [
            .firstText: [InitialStartTextCellViewModel(
                props: .init(title: R.string.localizable.finishFirstInfo())
            )],
            .edit: mapEditViewModel(),
            .secondText: [InitialStartTextCellViewModel(
                props: .init(title: R.string.localizable.finishSecondInfo())
            )]
        ]
    }

    func mapEditViewModel() -> [InitialStartEditCellViewModel] {
        [InitialStartEditCellViewModel(
            props: .init(
                text: String(UserDefaultsHelper.calorieIntake) + " " + Measure.kcal.rawValue,
                onTap: Command { [weak self] in
                    self?.showEditDialog()
                }
            )
        )]
    }

    func showEditDialog() {
        let editDialog = with(DialogController()) {
            $0.props = $0.props.mutate {
                $0.title = R.string.localizable.finishAlertTitle()
                $0.value = Double(UserDefaultsHelper.calorieIntake)
                $0.measure = .kcal
                $0.onSave = CommandWith { [weak self] value in
                    guard let self, let value = value else { return }
                    UserDefaultsHelper.calorieIntake = Int(value)
                    self.pack[.edit] = self.mapEditViewModel()
                }
            }
        }
        router.showDialog(editDialog)
    }

    func finishSetup() {
        setParameterTypes()
        setParameters()
        router.runMainScreen()
    }

    func setParameterTypes() {
        Measure.allCases.forEach { [weak self] measure in
            guard let self else { return }
            self.service.create(ParameterType.self) { type in
                type.name = measure.rawValue
                type.measure = measure.rawValue
            }
            .subscribe()
            .disposed(by: disposeBag)
        }
    }

    func setParameters() {
        service.fetch(ParameterType.self)
            .bind { [weak self] types in
                guard let self else { return }
                types.forEach { type in
                    switch Measure(rawValue: type.name ?? "") {
                    case .sm:
                        UserDefaultsHelper.treckingParameters.forEach { param in
                            self.service.create(Parameter.self) { parameter in
                                self.map(&parameter, name: param.title, info: param.description, type: type)
                            }
                            .subscribe()
                            .disposed(by: self.disposeBag)
                        }
                    case .kg:
                        self.service.create(Parameter.self) { parameter in
                            self.map(&parameter, name: Measure.kg.rawValue, type: type)
                        }
                        .subscribe()
                        .disposed(by: self.disposeBag)
                    case .kcal:
                        self.service.create(Parameter.self) { parameter in
                            self.map(&parameter, name: Measure.kcal.rawValue, type: type)
                        }
                        .subscribe()
                        .disposed(by: self.disposeBag)
                    case .gramm:
                        Nutritions.allCases.forEach { nutrition in
                            self.service.create(Parameter.self) { parameter in
                                self.map(&parameter, name: nutrition.rawValue, type: type)
                            }
                            .subscribe()
                            .disposed(by: self.disposeBag)
                        }
                    default:
                        break
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    func map(_ parameter: inout Parameter, name: String, info: String? = nil, type: ParameterType) {
        parameter.name = name
        parameter.info = info
        parameter.parameterType = type
        type.addToTypeParameter(parameter)
    }
}
