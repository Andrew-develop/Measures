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

        setup()
    }
}

private extension InitialStartPresenter {
    func setup() {
        service.fetch(User.self)
            .bind { [weak self] user in
                if user.isEmpty {
                    self?.addUser()
                }
            }
            .disposed(by: disposeBag)

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

    private func addUser() {
        service.create(User.self) { newUser in
            newUser.height = 170.0
            newUser.weight = 60.0
            newUser.gender = Gender.male.description
            newUser.target = UserTarget.loseWeight.description
            newUser.activityLevel = ActivityLevel.good.title
            newUser.birthday = Date()
            newUser.calorieIntake = 2200
            newUser.userParameter = []
        }
        .subscribe()
        .disposed(by: disposeBag)
    }
}
