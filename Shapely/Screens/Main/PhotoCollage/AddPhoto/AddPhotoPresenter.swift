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

    private let image: UIImage
    private var note: Note?

    private var editableImage: UIImage = UIImage() {
        didSet {
            propsRelay.mutate {
                $0.state = .ready(editableImage)
            }
        }
    }

    init(service: AddPhotoServiceProvider,
         router: AddPhotoInternalRouter,
         image: UIImage) {
        self.service = service
        self.router = router
        self.image = image

        setup()
    }
}

private extension AddPhotoPresenter {
    func setup() {
        service.rx_maskedImage
            .bind { [weak self] fixedImage in
                self?.editableImage = fixedImage
            }
            .disposed(by: disposeBag)

        let predicate = NSPredicate(format: "date >= %@", Calendar.current.startOfDay(for: Date()) as CVarArg)
        service.fetch(Note.self, predicate: predicate)
            .bind { [weak self] notes in
                guard let currentNote = notes.first else {
                    self?.createNote()
                    return
                }
                self?.note = currentNote
            }
            .disposed(by: disposeBag)

        propsRelay.mutate {
            $0.state = .ready(image)
            $0.onAction = CommandWith<Int> { [weak self] value in
                guard let self, let action = PhotoEditItem(rawValue: value) else { return }
                self.propsRelay.mutate {
                    $0.editItem = action
                }
            }
            $0.onRemoveBack = Command { [weak self] in
                guard let self else { return }
                self.propsRelay.mutate {
                    $0.state = .loading
                }
                self.service.prepareImage(self.image)
            }
            $0.confirmProps = ConfirmView.Props(
                state: .regular,
                title: R.string.localizable.buttonSave(),
                onContinue: Command { [weak self] in
                    self?.saveImage()
                },
                onBack: .empty
            )
        }
    }

    func createNote() {
        service.create(Note.self) { note in
            note.date = Date()
        }
        .bind { [weak self] currentNote in
            self?.note = currentNote
        }
        .disposed(by: disposeBag)
    }

    func saveImage() {
        guard let data = editableImage.pngData() else { return }
        service.create(Photo.self) { [weak self] photo in
            guard let self else { return }
            photo.value = data
            photo.angel = Angel.front.description
            photo.photoNote = self.note
        }
        .bind { [weak self] _ in
            self?.service.notify()
            self?.router.pop()
        }
        .disposed(by: disposeBag)
    }
}
