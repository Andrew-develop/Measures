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

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: InitialStartServiceProvider, router: InitialStartInternalRouter) {
        self.service = service
        self.router = router

        mapStartPack()
    }
}

private extension InitialStartPresenter {
    func mapStartPack() {
        propsRelay.mutate {
            $0.pack = InitialStartPack(
                header: MainHeaderCellViewModel(
                    props: MainHeaderCell.Props(
                        title: R.string.localizable.initialStartTitle()
                    )
                ),
                viewModels: [
                    .text(
                        InitialStartTextCellViewModel(
                            props: InitialStartTextCell.Props(
                                title: R.string.localizable.initialStartInfo()
                            )
                        )
                    ),
                    .picture(
                        InitialStartPictureCellViewModel(
                            props: InitialStartPictureCell.Props(
                                picture: R.image.initialStart()
                            )
                        )
                    )
                ]
            )
            $0.confirmProps = ConfirmView.Props(
                state: .regular,
                title: R.string.localizable.buttonStart(),
                onContinue: Command { [weak self] in
                    self?.mapPersonalInfoPack()
                },
                onBack: .empty
            )
        }
    }

    func mapPersonalInfoPack() {
        propsRelay.mutate {
            $0.confirmProps = ConfirmView.Props(
                state: .regular,
                title: R.string.localizable.buttonContinue(),
                onContinue: Command { [weak self] in
                    self?.mapWeightPack()
                },
                onBack: .empty
            )
        }
    }

    func mapWeightPack() {}

    func mapParametersPack() {}

    func mapFinalPack() {}
}
