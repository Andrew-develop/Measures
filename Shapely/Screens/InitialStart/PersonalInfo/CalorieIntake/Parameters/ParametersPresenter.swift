//
//  ParametersPresenter.swift
//  Shapely
//
//  Created by Andrew on 01.04.2023.
//

import RxSwift
import RxCocoa

final class ParametersPresenter: PropsProducer {
    typealias Props = ParametersViewController.Props

    private let service: InitialStartServiceProvider
    private let router: ParametersInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    private var pack: [InitialStartSection.Parameters: [AnyHashable]] = [:] {
        didSet {
            propsRelay.mutate {
                $0.pack = pack
            }
        }
    }

    init(service: InitialStartServiceProvider, router: ParametersInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension ParametersPresenter {
    func setup() {
        propsRelay.mutate {
            $0.title = R.string.localizable.parametersTitle()
            $0.confirmProps = ConfirmView.Props(
                state: .full,
                title: R.string.localizable.buttonContinue(),
                onContinue: Command { [weak self] in
                    self?.router.runFinishScreen()
                },
                onBack: Command { [weak self] in
                    self?.router.runCalorieIntakeScreen()
                }
            )
        }

        pack = [
            .values: mapParameters()
        ]
    }

    func mapParameters() -> [InitialStartParameterCellViewModel] {
        TreckingParameter.allCases.sorted {
            UserDefaultsHelper.treckingParameters.contains($0) &&
            !UserDefaultsHelper.treckingParameters.contains($1)
        }
        .map { parameter in
            InitialStartParameterCellViewModel(
                props: InitialStartParameterCell.Props(
                    parameter: parameter,
                    isSelected: UserDefaultsHelper.treckingParameters.contains(parameter),
                    onTap: Command { [weak self] in
                        self?.setParameter(parameter)
                    }
                )
            )
        }
    }

    func setParameter(_ parameter: TreckingParameter) {
        var parameters = UserDefaultsHelper.treckingParameters
        if parameters.contains(parameter) {
            parameters.remove(parameter)
        } else {
            parameters.insert(parameter)
        }
        UserDefaultsHelper.setTreckingParameters(parameters)
        pack[.values] = mapParameters()
    }
}
