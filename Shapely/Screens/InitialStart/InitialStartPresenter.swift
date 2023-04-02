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

    private let router: InitialStartInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(router: InitialStartInternalRouter) {
        self.router = router

        setup()
    }
}

private extension InitialStartPresenter {
    func setup() {
        propsRelay.mutate {
            $0.title = R.string.localizable.initialStartTitle()
            $0.pack = [
                .text: [InitialStartTextCellViewModel(
                    props: .init(title: R.string.localizable.initialStartInfo())
                )],
                .picture: [InitialStartPictureCellViewModel(
                    props: .init(picture: R.image.initialStart(), onTap: .empty)
                )]
            ]
            $0.confirmProps = ConfirmView.Props(
                state: .regular,
                title: R.string.localizable.buttonStart(),
                onContinue: Command { [weak self] in
                    self?.router.runPersonalInfoScreen()
                },
                onBack: .empty
            )
        }
    }
}
