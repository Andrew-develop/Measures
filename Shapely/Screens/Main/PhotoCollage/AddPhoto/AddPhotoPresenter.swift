//
//  AddPhotoPresenter.swift
//  Shapely
//
//  Created by Andrew on 13.03.2023.
//

import RxSwift
import RxCocoa

final class AddPhotoPresenter: PropsProducer {
    typealias Props = AddPhotoViewController.Props

    private let service: AddPhotoServiceProvider
    private let router: AddPhotoInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    init(service: AddPhotoServiceProvider, router: AddPhotoInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension AddPhotoPresenter {
    func setup() {
        service.rx_maskedImage
            .bind { [weak self] image in
                self?.propsRelay.mutate {
                    $0.image = image
                }
            }
            .disposed(by: disposeBag)

        propsRelay.mutate {
            $0.image = R.image.plus()
            $0.confirmProps = ConfirmView.Props(
                state: .regular,
                title: R.string.localizable.buttonSave(),
                onContinue: Command { [weak self] in
                    self?.saveImage()
                },
                onBack: .empty
            )
            $0.onTap = Command { [weak self] in
                self?.changePickerValue(true)
            }
            $0.onSelectImage = CommandWith<UIImage?> { [weak self] image in
                guard let image else { return }
                self?.changePickerValue(false)
                self?.service.prepareImage(image)
            }
        }
    }

    func changePickerValue(_ value: Bool) {
        propsRelay.mutate {
            $0.isNeedShowPicker = value
        }
    }

    func saveImage() {
        guard let data = propsRelay.value.image?.pngData() else { return }
        service.addPhoto { photo in
            photo.value = data
            photo.angel = Angel.front.description
        }.bind { [weak self] _ in
            self?.service.notify()
            self?.router.pop()
        }
        .disposed(by: disposeBag)
    }
}
