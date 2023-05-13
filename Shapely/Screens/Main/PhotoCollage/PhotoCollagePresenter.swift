//
//  PhotoCollagePresenter.swift
//  Shapely
//
//  Created by Andrew on 11.03.2023.
//

import RxSwift
import RxCocoa

final class PhotoCollagePresenter: PropsProducer {
    typealias Props = PhotoCollageViewController.Props

    private let service: PhotoCollageServiceProvider
    private let router: PhotoCollageInternalRouter
    private let disposeBag = DisposeBag()

    private let propsRelay = BehaviorRelay<Props>(value: .default)
    var rx_props: Driver<Props> {
        propsRelay.asDriver()
    }

    private var byDays: Bool = true

    private var categories: [Angel: [AnyHashable]] = [:] {
        didSet {
            propsRelay.mutate {
                $0.category = categories
            }
        }
    }

    private var days: [AnyHashable] = [] {
        didSet {
            propsRelay.mutate {
                $0.days = days
            }
        }
    }

    init(service: PhotoCollageServiceProvider, router: PhotoCollageInternalRouter) {
        self.service = service
        self.router = router

        setup()
    }
}

private extension PhotoCollagePresenter {
    func setup() {
        if byDays {
            getNotes()
        } else {
            getPhotos()
        }

        propsRelay.mutate {
            $0.title = R.string.localizable.photoCollageTitle()
            $0.byDays = byDays
            $0.onSelectImage = CommandWith<UIImage?> { [weak self] image in
                guard let image else { return }
                self?.changePickerValue(false)
                self?.router.runAddPhotoScreen(image)
            }
        }

        service.rx_savedImage
            .bind { [weak self] in
                self?.getPhotos()
            }
            .disposed(by: disposeBag)
    }

    func getNotes() {
        service.fetch(Note.self)
            .bind { [weak self] notes in
                self?.mapNotes(notes.reversed())
            }
            .disposed(by: disposeBag)
    }

    func getPhotos() {
        service.fetch(Photo.self)
            .bind { [weak self] photos in
                self?.mapPhotoCategories(photos.reversed())
            }
            .disposed(by: disposeBag)
    }

    func mapNotes(_ notes: [Note]) {
        days = notes.compactMap { note in
            guard let photos = note.notePhoto?.allObjects as? [Photo], !photos.isEmpty else { return nil }

            let firstImage = photos.first { photo in
                photo.angel == Angel.front.description
            }
            let secondImage = photos.first { photo in
                photo.angel == Angel.side.description
            }
            let thirdImage = photos.first { photo in
                photo.angel == Angel.back.description
            }

            return DayPhotosCellViewModel(
                props: .init(
                    firstImage: UIImage(data: firstImage?.value ?? Data()),
                    secondImage: UIImage(data: secondImage?.value ?? Data()),
                    thirdImage: UIImage(data: thirdImage?.value ?? Data()),
                    onTap: .empty
                )
            )
        }
    }

    func mapPhotoCategories(_ photos: [Photo]) {
        Angel.allCases.forEach { [weak self] angel in
            guard let self else { return }
            let categoryPhotos = photos.filter { $0.angel == angel.description }
            let title = InitialStartTitleCellViewModel(props: .init(title: angel.description))
            let values = PhotoTypesCellViewModel(
                props: .init(
                    id: UUID(),
                    items: self.mapPhotos(categoryPhotos)
                )
            )
            let addWidget = AddWidgetCellViewModel(
                props: .init(
                    title: R.string.localizable.photoCollageAddPhoto(),
                    onTap: Command { [weak self] in
                        self?.changePickerValue(true)
                    }
                )
            )
            self.categories[angel] = !categoryPhotos.isEmpty ? [title, values] : [title, addWidget]
        }
    }

    func mapPhotos(_ photos: [Photo]) -> [PhotoVariantCellViewModel] {
        photos.map { photo in
            PhotoVariantCellViewModel(
                props: .init(
                    id: UUID(),
                    image: UIImage(data: photo.value ?? Data()),
                    onTap: .empty
                )
            )
        }
    }

    func changePickerValue(_ value: Bool) {
        propsRelay.mutate {
            $0.isNeedShowPicker = value
        }
    }
}
